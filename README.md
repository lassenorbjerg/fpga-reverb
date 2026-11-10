# FPGA Reverb
<intro paragraph + setup.svg>

## Status
| Feature | Branch/tag | Verilog | XDC | Works |
|  ---  |  ---  |  ---  |  ---  |  ---  |
| Real-time raw playback | 0.3.0 | echoNew.v | echoNew.xdc | Yes. It is undistorted playback. Although it does have a fairly significant delay ~90ms |



## Requirements
- Hardware: Basys3, micro-USB cable, microphone (+ optional audio interface), headphones
- Software: JDK 21, sbt, Vivado 2025.1, Python ≥3.10
- Chisel toolchain: https://github.com/schoeberl/chisel-lab/blob/master/Setup.md
  (Windows gotchas, sbt path without spaces, Metals: see docs/setup.md)

## Build the hardware
sbt test
sbt "runMain top.Top"        # -> generated/<feature>.v

## Program the FPGA (Vivado)
1. New RTL project, part xc7a35tcpg236-1
2. Add generated/<feature>.v as source + xdc/<feature>.xdc as constraint
3. Generate bitstream → Hardware Manager → Program
> Naming: every major feature has its own generated/<feature>.v and a matching
> xdc/<feature>.xdc with the same base name. xdc/Basys3_Master.xdc is the untouched Digilent template.

## Host setup
### Python env
cd scripts; python -m venv .venv; .\.venv\Scripts\activate.ps1; pip install -r requirements.txt
### Find the COM port
python -m serial.tools.list_ports
### Set baud rate (Windows)
Device Manager → Ports (COM & LPT) → USB Serial Port → Properties → Port Settings → 921600
> Must match Env.BaudRate in src/main/scala/utils/Env.scala
### Audio
Pick the mic/interface as Windows default input. Use headphones (feedback).

## Run
python scripts/serial_send.py COM4 -b 921600 -r 44100 --recv play   # live mic through FPGA
python scripts/serial_send.py --no-serial --recv play                # no board, loopback
python scripts/serial_file.py COM4 audio.wav                         # file round trip
python scripts/uart_debug.py COM4                                    # link diagnosis

## Repository layout → docs/files.md
## Report → report/report.md
## License
