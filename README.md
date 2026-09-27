# FPGA Reverb

Real-time audio effects using an FPGA

`*-postfix` is the current version

# 0.2.0

# 0.1.0*

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

#### [For later]
- Memory module (memoryManager)
  - Receives data from serialRecv
  - Saves it in a register
  - Sends it to serialSend

### Protocols

Interfaces using ready/valid, buses, or custom protocols

- UART Protocol
  - serialSend
  - serialRecv

- ready/valid
  - 

### Memory Placement and Type

### FSMD

### Area Estimation

### Latency Estimation

## Chisel File Structure

## Implement in Chisel

## Tests

## Synthesize to Hardware



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
