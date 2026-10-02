# FPGA Reverb

Real-time audio effects using an FPGA

`*-postfix` is the current version. There are branches for each version.

Go to [test](#practical)

# 0.3.2 - Using FIFO to delay input

This is building on top of Third iteration.

## Microarchitecture Design

Delay FIFO. e.g. 10 clock cycles to see in simulation.

Delay FIFO multiple ms

### Modules

- UART Send module (serialSend)
- UART Receive module (serialRecv)
- Memory module (memoryManager)
  - Receives data from serialRecv
  - Saves it in BRAM FIFO
  - Sends it to serialSend after configurable amount of clock cycles

# 0.3.1 - Creating FIFO in BRAM

This is building on top of Third iteration.

Create a FIFO using BRAM.


# 0.3.0 - creating BRAM

This is the Third iteration of the design.

Save a value in BRAM.
Vivado should say that BRAM is created

# 0.2.0 - controlling volume

This is the second iteration of the design.

Host sends audio through UART.

Device also have switches as input.
Device sends audio back scaled by switches through UART.

# 0.1.0* - Sending and receiving audio

This is the first iteration of the design.

Here we just want host sending input through UART.
Device sending it back unaltered through UART.

## Hardware Specification (Device)
### Inputs

The host sends microphone data through UART
- PCM samples as UART bytes
  - 8 bits + 2 (start,stop)

### Outputs

The host receives data through UART
- Unaltered PCM input
  - Same format as input

### Clock and reset behavior

- One clock cycle delay?
  - Save in register, might be needed
  - The baud rate vs global clock muddies what this delay means
- Reset resets the UART handshake

### Data widths and numeric formats

- pcm data will be uint8

### Latency and throughput

- Should not notice a delay when audio is playing back

### Memory requirements

- BRAM is not used in this iteration. One layer buffer might be all that is needed
- Possibly big enough to have one sample block

### Error and corner-case behavior

- Dropping samples
- Clipping
- Distorted playback

### Target

- Basys3 FPGA board

## Microarchitecture Design

### Modules

- UART Send module (serialSend)
- UART Receive module (serialRecv)

For 0.1.0 we connect them directly
```
serialSend.bits := serialRecv.bits
```

### Protocols

Interfaces using ready/valid, buses, or custom protocols

- UART Protocol
  - serialSend
  - serialRecv

### Memory Placement and Type

- UART uses registers to match clock speed with baud rate

### FSMD

![alt text](docs/fsmd0_1_0.drawio.svg)

### Area Estimation

- Tx
  - 10 bits for Tx shift reg
  - counter reg is 20 bits
  - bits reg is 4 bits
  - 2x equality (20.w+4.w)
  - 1x not (4)
  - 1x and (1w&1w)
  - 1 x right shift (10.w)
  - 1 x adder (4.w)
- Rx
  - Similar to Tx

#### Rough estimate
- eq = ceil(60 / 6) +  ceil(12 / 6) = 12
- not = 1
- and = 1
- right shift = ceil(30 / 6) = 5
- adder = 2
- 12+1+1+5+2 = 21 6LUT

- total: ~50 6LUT (RX has more than Tx)
- 80 x dff (RX has more than Tx)

### Latency Estimation

Assuming one baud cycle.

## Chisel File Structure

```
fpga-reverb/
├── build.sbt
├── project/
│   ├── build.properties
├── scripts/
│   ├── requirements.txt
│   ├── serial_recv.py
│   └── serial_send.py
├── src/
│   ├── main/
│   │   └── scala/
│   │       └── serial/
│   │           ├── serialSend.scala
│   │           └── serialRecv.scala
│   └── test/
│       └── scala/
│           └── serial/
│               ├── serialSendSpec.scala
│               └── serialRecvSpec.scala
├── Basys3_Master.xdc
└── README.md
```

### build.properties

```
sbt.version = 1.13.0
```

## Implement in Chisel

Development notes are added here

## Tests

### serialRecvSpec

- UART host sender needs to be mocked (senderMock)
- Are the values from senderMock set in 

### serialSendSpec



## Synthesize to Hardware

Vivado will be used.
___

# Practical

## Development setup (VS Code + Metals)

### One-time setup per computer

1. Install **JDK 21** ([Temurin](https://adoptium.net/)). Set `JAVA_HOME` to it and put `%JAVA_HOME%\bin` first on `PATH`.
   Remove old Javas (e.g. Oracle Java 8) so `java -version` prints 21.
2. Install **sbt** in a path **without spaces**, e.g. `scoop install sbt` or `cs setup`.
   The Windows installer puts it in `C:\Program Files (x86)\sbt`, and the space in that path breaks Metals' connection to sbt.
   `where sbt` (`Get-Command` for ps1) should print only one location.
3. Install VS Code and the **Scala (Metals)** extension. In user settings, set `"metals.javaHome"` to the JDK 21 folder.

### First time opening the repo

1. `git clone` and open the folder in VS Code.
2. Click **Import build** when Metals asks. If it asks which build server to use, choose **Bloop**
   (to change it later: `Metals: Switch build server`).
3. Wait for the import to finish in the status bar. `Metals: Run doctor` should list `fpga-reverb` with Scala 2.13.18.

If red bar saying `No Target`: Press on it.

`.bsp/`, `.bloop/`, `.metals/`, `.vscode/` and `project/metals.sbt` are machine-specific and git-ignored.
`project/build.properties` is committed, so every computer uses the same sbt version.

### Every day

- Open the folder and wait for Metals to finish loading. That's all you need to do.
- After changing `build.sbt`, or pulling a change to it: accept the **Import build** prompt (or run `Metals: Import build`).
- If Metals misbehaves, try these in order:
  1. `Metals: Restart build server`
  2. `Metals: Import build`
  3. Close VS Code, delete `.bloop`, `.bsp`, `.metals`, `target` and `project/target`, reopen, then **Import build**.



## Running Tests

```sh
sbt test
```
You should see a whole bunch of output that ends with something like the following lines
```
[info] Tests: succeeded 1, failed 0, canceled 0, ignored 0, pending 0
[info] All tests passed.
[success] Total time: 5 s, completed Dec 16, 2020 12:18:44 PM
```


## Convert to SystemVerilog

```sh
sbt run
```

### Debugging

Ensure `emitVerilog` in object


## Host Setup

### Installing dependencies

```sh
cd scripts/
```

The rest of the commands are assumed to be in `scripts/`

```sh
python -m venv .venv
```

#### Bash
```sh
source .venv/bin/activate
```

#### Powershell

```ps1
.\.venv\Scripts\activate.ps1
```

___

Should look like this after activating
```sh
(.venv) fpga-reverb/scripts>
```
The rest of the commands are assumed to be in the activated virtual environment.
___
To install the dependencies run

```sh
pip install -r ./requirements.txt
```

### Running script

Help found at
```sh
python ./serial_send.py --help
```

Simple usage
```
python ./serial_send.py MIC_PORT
```


A typical example for windows
```sh
python scripts/serial_send.py COM3
```
