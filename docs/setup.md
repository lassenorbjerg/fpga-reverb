# Setup

# Practical

## Development setup (VS Code + Metals)

### One-time setup per computer

1. Install **JDK 21** ([Temurin](https://adoptium.net/)). Set `JAVA_HOME` to it and put `%JAVA_HOME%\bin` first on `PATH`.
   Remove old Javas (e.g. Oracle Java 8) so `java -version` prints 21.
2. Install **sbt** in a path **without spaces**, e.g. `scoop install sbt` or `cs setup`.
   The Windows installer puts it in `C:\Program Files (x86)\sbt`, and the space in that path breaks Metals' connection to sbt.
   `where sbt` (`Get-Command` for ps1) should print only one location.
3. Install VS Code and the **Scala (Metals)** extension. In user settings, set `"metals.javaHome"` to the JDK 21 folder.
4. Install **firtool** (only needed when generating with `circt.stage.ChiselStage`, e.g. `emitSystemVerilog`).
   Chisel 3.6.1 expects **firtool 1.37.0**.
   1. Download the Windows zip from the [firtool-1.37.0 release](https://github.com/llvm/circt/releases/tag/firtool-1.37.0).
      - Chisel (3.6.1) was published against firtool version 1.37.0.
   2. Unzip it to a path **without spaces**, e.g. `C:\tools\firtool-1.37.0`.
   3. Add its `bin` folder to `PATH`, e.g. in PowerShell:
      ```ps1
      $u = [Environment]::GetEnvironmentVariable("Path", "User")
      [Environment]::SetEnvironmentVariable("Path", "$u;C:\tools\firtool-1.37.0\bin", "User")
      ```
   4. Open a new terminal and restart VS Code. `firtool --version` should print `1.37.0`.

   Without it, `sbt run` fails with `FirtoolNonZeroExitCode ... ExitCode: -1` and an empty STDERR.
   The legacy `chisel3.stage.ChiselStage().emitVerilog` does not need firtool.

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

> [!note] Intellisense only works in Metals when it can be compiled. i.e. does `sbt run` work.


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


___

```

python scripts/serial_recv.py -h, python scripts/serial_send.py -h: the CLIs parse.
python scripts/serial_send.py --no-serial --recv play: you hear your mic with about 100 ms of delay (use headphones).
python scripts/serial_send.py --no-serial --recv hex: a hex dump scrolls.
With the Basys3 echo design: python scripts/serial_send.py COM3 -b <baud> --recv play plays the echoed audio, and --recv hex shows the echoed bytes. python scripts/serial_recv.py COM3 -m hex works on its own.


python scripts/serial_send.py COM4 -b <baud> --recv play   # send mic, play what comes back
python scripts/serial_send.py COM4 -b <baud> --recv hex    # send mic, print the returned bytes
python scripts/serial_recv.py COM4 -m hex                  # receive only
python scripts/serial_send.py --no-serial --recv play      # no board: loops your mic back to the speakers
```

___

