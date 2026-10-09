#!/usr/bin/env python3
"""
Created by opus 5.5

```
make serial send and receive file. so you choose a path to a .wav file. it sends the file contents through uart. it should then be possible to receive data for a file through uart. you can use this to know when to start and stop listening for file

Start receive = 8'11111111 8'00000000
Stop receive = 8'11111111 8'00000000

and write received file data to a file in a folder in scripts/ called received_file/
```


Send a file (e.g. a .wav) through a UART port and rebuild the file that comes
back.

The file is framed with start/stop markers so the receiver knows which bytes
belong to the file:

    FF 00  <payload>  FF 00

Start and stop are the same two bytes, and FF 00 shows up often in 16-bit
audio, so the payload is byte-stuffed: every FF in the file is sent as FF FF.
Inside a frame, FF FF therefore means one data byte FF, and FF 00 means stop.
The FPGA echo design passes bytes through unchanged, so the stuffing survives
the round trip.  Use --raw to send the file unescaped (an FF 00 inside the
file will then end the received file early).

By default the file is sent and received on the same port at the same time
(Windows only lets one process open a COM port).  Received files are written
to scripts/received_file/.

Examples
--------
    python scripts/serial_file.py COM3 audio.wav
    python scripts/serial_file.py COM3 audio.wav --baud 115200
    python scripts/serial_file.py COM3 --recv-only            # wait for a file
    python scripts/serial_file.py COM3 audio.wav --send-only
    python scripts/serial_file.py --no-serial audio.wav       # loopback test

Requires:  pip install pyserial
"""

from __future__ import annotations

import argparse
import sys
import threading
import time
from datetime import datetime
from pathlib import Path

import serial

from serial_send import BITS_PER_BYTE_ON_WIRE, DEFAULT_BAUD, list_ports, normalize_port

START = b"\xff\x00"
STOP = b"\xff\x00"
ESC = 0xFF

RECEIVED_DIR = Path(__file__).resolve().parent / "received_file"
CHUNK = 1024  # bytes per write, so progress updates and Ctrl-C stay responsive


def frame(payload: bytes, raw: bool = False) -> bytes:
    """Wrap ``payload`` in start/stop markers, stuffing FF bytes unless ``raw``."""
    body = payload if raw else payload.replace(b"\xff", b"\xff\xff")
    return START + body + STOP


class FileDecoder:
    """Pulls one framed file out of a byte stream.

    Bytes before the start marker are ignored.  ``done`` is set once the stop
    marker has been seen; ``data`` then holds the unstuffed file contents.
    """

    def __init__(self, raw: bool = False) -> None:
        self.raw = raw
        self.data = bytearray()
        self.started = threading.Event()
        self.done = threading.Event()
        self.bytes_received = 0
        self.last_rx = time.monotonic()
        self._prev = None  # last byte while waiting for the start marker
        self._pending_ff = False  # saw FF inside the frame, next byte decides

    def feed(self, chunk: bytes) -> None:
        if not chunk:
            return
        self.bytes_received += len(chunk)
        self.last_rx = time.monotonic()
        for b in chunk:
            if self.done.is_set():
                return
            if not self.started.is_set():
                if self._prev == START[0] and b == START[1]:
                    self.started.set()
                self._prev = b
                continue
            if not self._pending_ff:
                if b == ESC:
                    self._pending_ff = True
                else:
                    self.data.append(b)
                continue
            # Previous byte was FF.
            if b == STOP[1]:
                self._pending_ff = False
                self.done.set()
            elif b == ESC and not self.raw:
                self.data.append(ESC)  # FF FF -> literal FF
                self._pending_ff = False
            elif b == ESC:
                self.data.append(ESC)  # raw: first FF was data, this one may start STOP
            else:
                # Raw FF followed by data (or a stray FF when stuffing): keep both.
                self.data.append(ESC)
                self.data.append(b)
                self._pending_ff = False


def reader_loop(ser, decoder: FileDecoder, stop: threading.Event) -> None:
    while not stop.is_set() and not decoder.done.is_set():
        try:
            data = ser.read(ser.in_waiting or 1)
        except serial.SerialException as exc:
            print(f"\nerror: read failed: {exc}", file=sys.stderr)
            stop.set()
            return
        decoder.feed(data)


def output_path(args: argparse.Namespace) -> Path:
    if args.output:
        return Path(args.output)
    suffix = Path(args.file).suffix if args.file else ".wav"
    stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return RECEIVED_DIR / f"received_{stamp}{suffix}"


def save(decoder: FileDecoder, path: Path, partial: bool) -> Path:
    if partial:
        path = path.with_name(path.stem + "_partial" + path.suffix)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(bytes(decoder.data))
    return path


def progress(sent: int, total: int, decoder) -> str:
    line = f"\rTX {sent / 1024:8.1f}/{total / 1024:.1f} KiB ({sent / max(total, 1):4.0%})"
    if decoder is not None:
        state = "done" if decoder.done.is_set() else "receiving" if decoder.started.is_set() else "waiting"
        line += f"  |  RX {len(decoder.data) / 1024:8.1f} KiB  {state}"
    return line + "   "


def run(args: argparse.Namespace) -> int:
    send = not args.recv_only
    recv = not args.send_only

    payload = b""
    if send:
        src = Path(args.file)
        if not src.is_file():
            print(f"error: no such file: {src}", file=sys.stderr)
            return 1
        payload = src.read_bytes()
    wire = frame(payload, args.raw) if send else b""

    ser = None
    if not args.no_serial:
        port = normalize_port(args.port)
        try:
            ser = serial.Serial(port, args.baud, timeout=0.1)
        except serial.SerialException as exc:
            print(f"error: could not open {port}: {exc}", file=sys.stderr)
            print("       run with --list-ports to see what is available.", file=sys.stderr)
            return 1
        ser.reset_input_buffer()
        target = f"{port} @ {args.baud} baud"
    else:
        target = "(--no-serial loopback)"

    decoder = FileDecoder(args.raw) if recv else None
    stop = threading.Event()
    reader = None
    if decoder is not None and ser is not None:
        reader = threading.Thread(
            target=reader_loop, args=(ser, decoder, stop), name="uart-reader", daemon=True
        )

    if send:
        secs = len(wire) * BITS_PER_BYTE_ON_WIRE / args.baud
        print(
            f"Sending {args.file} ({len(payload)} B, {len(wire)} B framed) -> {target}, "
            f"~{secs:.1f} s"
        )
    if recv:
        print(f"Receiving file from {target}")
    print("Ctrl-C to stop.\n")

    started = time.monotonic()
    interrupted = False
    try:
        if reader is not None:
            reader.start()
        sent = 0
        for i in range(0, len(wire), CHUNK):
            if stop.is_set():
                break
            chunk = wire[i : i + CHUNK]
            if ser is not None:
                ser.write(chunk)  # blocking; the port paces the loop
            elif decoder is not None:
                decoder.feed(chunk)  # loopback: pretend the FPGA echoed it
            sent += len(chunk)
            sys.stdout.write(progress(sent, len(wire), decoder))
            sys.stdout.flush()
        if ser is not None and send:
            ser.flush()

        # Wait for the stop marker.  Before anything arrives (receive-only),
        # wait indefinitely; once data has flowed, give up after --timeout
        # seconds of silence.
        if decoder is not None:
            decoder.last_rx = time.monotonic()
            while not decoder.done.is_set() and not stop.is_set():
                time.sleep(0.1)
                sys.stdout.write(progress(sent, len(wire), decoder))
                sys.stdout.flush()
                idle = time.monotonic() - decoder.last_rx
                waiting_forever = args.recv_only and not decoder.started.is_set()
                if not waiting_forever and idle > args.timeout:
                    print(f"\n\nwarning: no stop marker after {args.timeout:.1f} s of silence.",
                          file=sys.stderr)
                    break
    except KeyboardInterrupt:
        interrupted = True
    except serial.SerialException as exc:
        print(f"\nerror: write failed: {exc}", file=sys.stderr)
    finally:
        stop.set()
        if reader is not None and reader.is_alive():
            reader.join(timeout=1.0)
        if ser is not None:
            ser.close()

    elapsed = time.monotonic() - started
    print(f"\n\nDone in {elapsed:.1f} s.")
    if decoder is None:
        return 0
    if not decoder.started.is_set():
        print("No start marker received; nothing saved.", file=sys.stderr)
        return 1

    complete = decoder.done.is_set()
    path = save(decoder, output_path(args), partial=not complete)
    print(f"{'Saved' if complete else 'Saved INCOMPLETE file'} ({len(decoder.data)} B): {path}")
    if send and complete:
        if bytes(decoder.data) == payload:
            print("Received file is identical to the sent file.")
        else:
            print("Received file differs from the sent file.")
    return 0 if complete and not interrupted else 1


def parse_args(argv=None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Send a file through UART framed by FF 00 markers, and save the file that comes back.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "port", nargs="?", help='serial port: "COM3", "COM/3", "3", or "/dev/ttyUSB0"'
    )
    parser.add_argument("file", nargs="?", help="file to send, e.g. audio.wav")
    parser.add_argument("-b", "--baud", type=int, default=DEFAULT_BAUD, help="baud rate")
    parser.add_argument(
        "-o", "--output",
        help="where to save the received file (default: scripts/received_file/received_<time>.<ext>)",
    )
    parser.add_argument(
        "-t", "--timeout", type=float, default=3.0,
        help="seconds of silence before giving up on the stop marker",
    )
    parser.add_argument(
        "--raw", action="store_true",
        help="do not escape FF bytes (FF 00 inside the file will end it early)",
    )
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--send-only", action="store_true", help="only send, do not receive")
    mode.add_argument("--recv-only", action="store_true", help="only receive, no file needed")
    parser.add_argument(
        "--no-serial", action="store_true",
        help="no port: loop the sent bytes straight into the receiver (test without a board)",
    )
    parser.add_argument("--list-ports", action="store_true", help="list serial ports and exit")
    args = parser.parse_args(argv)

    # With --no-serial the only positional is the file.
    if args.no_serial and args.port and not args.file:
        args.file, args.port = args.port, None
    # With --recv-only the file is optional.
    return args


def main(argv=None) -> int:
    args = parse_args(argv)
    if args.list_ports:
        list_ports()
        return 0
    if args.no_serial and (args.send_only or args.recv_only):
        print("error: --no-serial loops back, so it needs both send and receive.", file=sys.stderr)
        return 2
    if not args.port and not args.no_serial:
        print("error: no port given. Try --list-ports. For help -h", file=sys.stderr)
        return 2
    if not args.recv_only and not args.file:
        print("error: no file given to send (or use --recv-only).", file=sys.stderr)
        return 2
    return run(args)


if __name__ == "__main__":
    sys.exit(main())
