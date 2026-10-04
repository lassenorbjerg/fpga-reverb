#!/usr/bin/env python3
"""
Receive audio (or raw bytes) from a UART port.

The counterpart of serial_send.py: reads the continuous little-endian PCM
stream coming back from the FPGA and either plays it on the default (or
selected) output device, or dumps the raw bytes as hex.

Windows only lets one process open a COM port, so to send and receive at the
same time use ``serial_send.py --recv play|hex`` -- it runs this receiver on
the port it already has open.  Run this script on its own for receive-only.

Examples
--------
    python scripts/serial_recv.py COM3
    python scripts/serial_recv.py COM3 --mode hex
    python scripts/serial_recv.py 3 --baud 2000000 --rate 16000 --bits 8
    python scripts/serial_send.py COM3 --recv play      # send + receive

Requires:  pip install pyserial sounddevice numpy
"""

from __future__ import annotations

import argparse
import sys
import threading
import time

import numpy as np
import serial
import sounddevice as sd

from serial_send import (
    BITS_PER_BYTE_ON_WIRE,
    DEFAULT_BAUD,
    DEFAULT_BITS,
    DEFAULT_BLOCK,
    DEFAULT_MAX_LATENCY,
    DEFAULT_RATE,
    list_devices,
    list_ports,
    meter,
    normalize_port,
)

MODES = ("play", "hex")
HEX_ROW = 16


class Receiver:
    """Turns received UART bytes into audio output or a hex dump.

    ``feed`` is called from the reader thread; in play mode the audio
    callback drains a jitter buffer that ``feed`` fills.
    """

    def __init__(
        self,
        mode: str,
        rate: int = DEFAULT_RATE,
        bits: int = DEFAULT_BITS,
        gain: float = 1.0,
        max_latency: float = DEFAULT_MAX_LATENCY,
        block: int = DEFAULT_BLOCK,
        device=None,
        out=sys.stdout,
    ) -> None:
        self.mode = mode
        self.rate = rate
        self.bits = bits
        self.gain = gain
        self.block = block
        self.device = device
        self.out = out
        self.bytes_per_sample = 1 if bits == 8 else 2

        bytes_per_ms = rate * self.bytes_per_sample / 1000.0
        self.max_bytes = self._align(max(block * self.bytes_per_sample * 2,
                                         int(max_latency * bytes_per_ms)))
        # Wait for half the budget before playing so jitter doesn't underrun.
        self.prime_bytes = self._align(self.max_bytes // 2)

        self.buf = bytearray()
        self.lock = threading.Lock()
        self.priming = True
        self.stream = None

        self.bytes_received = 0
        self.underruns = 0
        self.overflows = 0
        self.xruns = 0
        self.peak = 0.0
        self.hex_offset = 0

    def _align(self, n: int) -> int:
        return n - n % self.bytes_per_sample

    def start(self) -> None:
        if self.mode != "play":
            return
        self.stream = sd.OutputStream(
            samplerate=self.rate,
            blocksize=self.block,
            device=self.device,
            channels=1,
            dtype="int16",
            callback=self._callback,
        )
        self.stream.start()

    def stop(self) -> None:
        if self.stream is not None:
            self.stream.stop()
            self.stream.close()
            self.stream = None

    def feed(self, data: bytes) -> None:
        if not data:
            return
        self.bytes_received += len(data)
        if self.mode == "hex":
            self._dump(data)
            return
        with self.lock:
            self.buf += data
            excess = len(self.buf) - self.max_bytes
            if excess > 0:
                # Drop the stalest audio, keeping sample alignment.
                excess += (-excess) % self.bytes_per_sample
                del self.buf[:excess]
                self.overflows += 1

    def _dump(self, data: bytes) -> None:
        lines = []
        for i in range(0, len(data), HEX_ROW):
            row = data[i : i + HEX_ROW]
            hexes = " ".join(f"{b:02x}" for b in row)
            text = "".join(chr(b) if 32 <= b < 127 else "." for b in row)
            lines.append(f"{self.hex_offset:08x}  {hexes:<{HEX_ROW * 3 - 1}}  |{text}|\n")
            self.hex_offset += len(row)
        self.out.write("".join(lines))
        self.out.flush()

    def _decode(self, raw: bytes) -> np.ndarray:
        if self.bits == 8:
            samples = (np.frombuffer(raw, dtype=np.uint8).astype(np.float32) - 128.0) * 256.0
        else:
            samples = np.frombuffer(raw, dtype="<i2").astype(np.float32)
        return samples * self.gain

    def _callback(self, outdata, frames, time_info, status):
        if status:
            self.xruns += 1
        want = frames * self.bytes_per_sample
        with self.lock:
            if self.priming and len(self.buf) >= self.prime_bytes:
                self.priming = False
            if self.priming:
                raw = b""
            else:
                raw = bytes(self.buf[:want])
                del self.buf[:want]
                if len(raw) < want:
                    self.underruns += 1
                    self.priming = True

        outdata.fill(0)
        if raw:
            samples = self._decode(raw)
            n = len(samples)
            outdata[:n, 0] = np.clip(samples, -32768, 32767).astype(np.int16)
            self.peak = max(self.peak, float(np.max(np.abs(samples))) / 32768.0)

    def buffered_ms(self) -> float:
        return len(self.buf) / self.bytes_per_sample / self.rate * 1000.0

    def status(self) -> str:
        s = (
            f"RX [{meter(self.peak)}] {self.bytes_received / 1024:8.1f} KiB  "
            f"buf {self.buffered_ms():4.0f} ms  "
            f"under {self.underruns}  over {self.overflows}"
        )
        self.peak = 0.0
        return s

    def summary(self) -> str:
        s = f"Received {self.bytes_received / 1024:.1f} KiB"
        if self.mode == "play":
            s += f", {self.underruns} underruns, {self.overflows} overflows, {self.xruns} xruns"
        return s + "."


def reader_loop(ser, receiver: Receiver, stop: threading.Event) -> None:
    """Pump bytes from ``ser`` into ``receiver`` until ``stop`` is set.

    Relies on a short read timeout on ``ser`` so stopping stays responsive.
    """
    while not stop.is_set():
        try:
            data = ser.read(ser.in_waiting or 1)
        except serial.SerialException as exc:
            print(f"\nerror: read failed: {exc}", file=sys.stderr)
            stop.set()
            return
        receiver.feed(data)


def run(args: argparse.Namespace) -> int:
    port = normalize_port(args.port)
    bytes_per_sample = 1 if args.bits == 8 else 2
    wire_bps = args.rate * bytes_per_sample * BITS_PER_BYTE_ON_WIRE
    if args.mode == "play" and args.baud < wire_bps:
        print(
            f"warning: {args.baud} baud carries {args.baud // BITS_PER_BYTE_ON_WIRE} B/s, "
            f"but {args.rate} Hz x {bytes_per_sample} B needs "
            f"{args.rate * bytes_per_sample} B/s; playback will underrun.",
            file=sys.stderr,
        )

    try:
        ser = serial.Serial(port, args.baud, timeout=0.1)
    except serial.SerialException as exc:
        print(f"error: could not open {port}: {exc}", file=sys.stderr)
        print("       run with --list-ports to see what is available.", file=sys.stderr)
        return 1

    receiver = Receiver(
        args.mode,
        rate=args.rate,
        bits=args.bits,
        gain=args.gain,
        max_latency=args.max_latency,
        block=args.block,
        device=args.device,
    )
    stop = threading.Event()
    reader = threading.Thread(
        target=reader_loop, args=(ser, receiver, stop), name="uart-reader", daemon=True
    )

    what = (
        f"{args.rate} Hz mono, {args.bits}-bit -> speakers"
        if args.mode == "play"
        else "hex dump"
    )
    print(f"{port} @ {args.baud} baud -> {what}")
    print("Ctrl-C to stop.\n")

    started = time.monotonic()
    try:
        receiver.start()
        reader.start()
        while not stop.is_set():
            time.sleep(0.25)
            if args.mode == "play":
                sys.stdout.write("\r" + receiver.status() + "   ")
                sys.stdout.flush()
    except KeyboardInterrupt:
        pass
    except sd.PortAudioError as exc:
        print(f"\nerror: audio device: {exc}", file=sys.stderr)
        return 1
    finally:
        stop.set()
        if reader.is_alive():
            reader.join(timeout=1.0)
        receiver.stop()
        ser.close()

    elapsed = time.monotonic() - started
    print(f"\n\n{receiver.summary()} ({elapsed:.1f} s)")
    return 0


def parse_args(argv=None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Receive audio from a UART port and play it, or dump the bytes.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "port",
        nargs="?",
        help='serial port: "COM3", "COM/3", "3", or "/dev/ttyUSB0"',
    )
    parser.add_argument(
        "-m",
        "--mode",
        choices=MODES,
        default="play",
        help="play = decode and play audio, hex = print received bytes",
    )
    parser.add_argument(
        "-b", "--baud", type=int, default=DEFAULT_BAUD, help="baud rate"
    )
    parser.add_argument(
        "-r", "--rate", type=int, default=DEFAULT_RATE, help="sample rate in Hz"
    )
    parser.add_argument(
        "--bits",
        type=int,
        choices=(8, 16),
        default=DEFAULT_BITS,
        help="8 = unsigned 8-bit, 16 = signed 16-bit little-endian",
    )
    parser.add_argument(
        "--block", type=int, default=DEFAULT_BLOCK, help="frames per audio callback"
    )
    parser.add_argument(
        "--max-latency",
        type=float,
        default=DEFAULT_MAX_LATENCY,
        help="ms of received audio to buffer before dropping",
    )
    parser.add_argument(
        "-g", "--gain", type=float, default=1.0, help="linear output gain"
    )
    parser.add_argument(
        "-d",
        "--device",
        help="output device index or name substring (default: system default)",
    )
    parser.add_argument(
        "--list-ports", action="store_true", help="list serial ports and exit"
    )
    parser.add_argument(
        "--list-devices", action="store_true", help="list audio devices and exit"
    )
    args = parser.parse_args(argv)

    if args.device is not None and args.device.isdigit():
        args.device = int(args.device)
    return args


def main(argv=None) -> int:
    args = parse_args(argv)

    if args.list_ports:
        list_ports()
        return 0
    if args.list_devices:
        list_devices()
        return 0
    if not args.port:
        print("error: no port given. Try --list-ports. For help -h", file=sys.stderr)
        return 2
    return run(args)


if __name__ == "__main__":
    sys.exit(main())
