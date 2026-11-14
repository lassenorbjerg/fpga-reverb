# FPGA Reverb

This project explores real-time audio effects implemented in chisel synthesized the FPGA board Basys3. It has a focus on getting microphone input and adding reverb to it for a real-time "reverbed" playback.

This project is part of a 5 ECTS special course during my MSc in Computer Engineering at DTU. The learning [goals](docs/goals.md) of this project are primarily:
- Writing a real world application in chisel
  - Exploring how much should be written from the bottom up
- Learning about audio processing
  - Both in raw format and modifying it for musical applications
- Theory of Audio Effects
  - Creating a chisel framework such that audio effect ideas can just be created and integrated standalone
- Scheduling my own project in preparation for managerial tasks of the thesis

## Setup
The working setup is

```
1 mic -> 2 PC -> Python script -> UART -> 3 FPGA -> 4 Effects -> UART -> 5 PC -> 6 Speakers
```

<img src="report/docs/setup.svg" alt="setup" width="400"/>

The baud rate used is `921600` and sample rate of `44.1kHz`. 

> [!note] The baud rate is not default for UART.
> See section [Set baud rate (Windows)](#set-baud-rate-windows)

## Status
| Feature                    | Branch/tag | Verilog           | XDC                 | Works                                                                                          |
| -------------------------- | ---------- | ----------------- | ------------------- | ---------------------------------------------------------------------------------------------- |
| Playback with effect chain | 0.3.1      | effectChainGain.v | effectChainGain.xdc | Compiles. Not yet tested synthesis. Reduced the queues. Hopefully not breaking and less delay. |
| Real-time raw playback     | 0.3.0      | echoNew.v         | echoNew.xdc         | Yes. It is undistorted playback. Although it does have a fairly significant delay ~90ms        |



## Requirements
- Hardware: Basys3, micro-USB cable, microphone (+ optional audio interface), headphones
- Software: JDK 21, sbt, Vivado 2025.1, Python ≥3.10
- Chisel toolchain: https://github.com/schoeberl/chisel-lab/blob/master/Setup.md
  (Windows gotchas, sbt path without spaces, Metals: see [docs/setup.md](docs/setup.md))

## Build the hardware

First check that test passes
```sh
sbt test
```

Generate verilog to `generated/<feature>.v`
```sh
sbt "runMain top.Top"
```
Alternatively since only one main
```sh
sbt run
```

## Program the FPGA (Vivado)
1. New RTL project with Basys-3 as the Board.
2. Add generated/<feature>.v as source + xdc/<feature>.xdc as constraint
3. Generate bitstream -> Hardware Manager -> Program
> Naming: every major feature has its own generated/<feature>.v and a matching
> xdc/<feature>.xdc with the same base name. xdc/Basys3_Master.xdc is the untouched Digilent template.

## Host setup
### Python env
#### Windows
```powershell
cd scripts; python -m venv .venv; .\.venv\Scripts\activate.ps1; pip install -r requirements.txt
```
#### Unix
```sh
cd scripts; python -m venv .venv; source .venv/bin/activate; pip install -r requirements.txt
```

### Find the COM port
```sh
python -m serial.tools.list_ports
```

> [!note] COM4 will be used in examples

### Set baud rate (Windows)
```
Device Manager -> Ports (COM & LPT) -> USB Serial Port -> Properties -> Port Settings -> 921600
```
> [!note] Must match Env.BaudRate in src/main/scala/utils/Env.scala

> [!note] Older usb ports do not support this high of a Baud Rate
### Audio
Pick the mic/interface as Windows default input. Use headphones (feedback).

## Run
```sh
python scripts/serial_send.py COM4 -b 921600 -r 44100 --recv play   # live mic through FPGA
python scripts/serial_send.py --no-serial --recv play                # no board, loopback
python scripts/serial_file.py COM4 audio.wav                         # file round trip
python scripts/uart_debug.py COM4                                    # link diagnosis
```

## Repository layout → docs/files.md
## Report → report/report.md
## License



