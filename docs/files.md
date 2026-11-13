# Files

One line per file. Add a row when you add a file. "Since" is the first version (tag) the file appeared in.

This is a very basic file overview. For proper documentation go to the code.

## src/main/scala/audio
| File        | Purpose                                                                                                     | Since |
| ----------- | ----------------------------------------------------------------------------------------------------------- | ----- |
| AudioEffect | Base class: Decoupled(SInt) in/out + `chain` helper                                                         | 0.3.0 |
| SampleCodec | Bytes <-> samples                                                                                           | 0.3.0 |
| AudioParams | Case class: widths, variables, etc. Params can be defined custom in tests. Otherwise use defaults from Env. | 0.3.0 |

## src/main/scala/serial

| File   | Purpose                                                    | Since |
| ------ | ---------------------------------------------------------- | ----- |
| UartTx | Custom Uart transmitter. Sends 1 start bit and 1 stop bit. | 0.3.0 |

## src/main/scala/top

| File      | Purpose                                                          | Since |
| --------- | ---------------------------------------------------------------- | ----- |
| AudioCore | Handles byte-level UART to samples. Chains together AudioEffects | 0.3.0 |
| Top       | Handles bit-level UART. Board specific things also handled here  | 0.3.0 |

## src/main/scala/utils

| File       | Purpose                                                             | Since |
| ---------- | ------------------------------------------------------------------- | ----- |
| Env        | Handles configuration defaults. Constants. Configurable data types. | 0.3.0 |
| VerilogGen | Object: Generates Verilog to given dir with given name.             | 0.3.0 |

## src/test/scala

This will be more generic. As the spec names are self-explanatory.

| File                    | Purpose                                            | Since |
| ----------------------- | -------------------------------------------------- | ----- |
| audio/AudioTestingUtils | Utils for generating and converting audio samples. | 0.3.0 |
| audio/SampleCodecSpec   | Has example of AudioTestingUtils.                  | 0.3.0 |

## generated

This contains the Verilog code of named features.

| File      | Purpose                                               | Since |
| --------- | ----------------------------------------------------- | ----- |
| echoNew.v | Working Echo from mic through setup. Has ~90ms delay. | 0.3.0 |

## xdc

This contains the Constraint `.xdc` files of named features.

| File          | Purpose                                                        | Since |
| ------------- | -------------------------------------------------------------- | ----- |
| Basys3_Master | Constraints with only `clock` and `reset`                      | 0.3.0 |
| echoNew       | Has 16 switches `io_sw` set and UART ports `io_txd`, `io_txr`. | 0.3.0 |

## scripts

| File | Purpose | Since |
| ---- | ------- | ----- |
|      |         |       |

## report

| File | Purpose | Since |
| ---- | ------- | ----- |
|      |         |       |

## docs

| File | Purpose | Since |
| ---- | ------- | ----- |
|      |         |       |
