# Utilizing DSP to create audio effects using FPGA

Lasse Nørbjerg s253860

December 2026


## Introduction



## Methods

### Setup

<img src="docs/setup.svg" alt="setup" width="400"/>

**Figure [^setup]: 1: Audio goes into microphone. 2: Microphone sends audio to PC. 3: PC sends audio data as PCM through UART to FPGA. 4: FPGA processes audio data. 5: FPGA sends processed audio back through UART. 6: PC plays the processed audio back to the user.**

### Hardware

FPGA board is the Basys3 board[^1]. It is part of the Artix-7 35t family[^1][^9].

For completeness. A Shure SM57 is going into a Focusrite Scarlett solo USB audio interface, into the PC. Despite this, any audio input device can be used (with- and without an audio interface). 

### Software

AMD Vivado 2025.1 will be used for synthesizing [^11]. The hardware will be described using Chisel [^12].

### Audio Format

Audio will be sent through the PC using PCM format[^4]. PCM has a `sample rate`, and the width of those samples called `bit depth`.

The expected bit depth and sample rate will be hardwired in the fpga. Future iterations could support a handshake exchanging typical header information.

The samples are usually signed in two's complement[^7]. We will therefore be using SInt in the Chisel code.

### BRAM as a FIFO

Industry records at 24-bit, 44.1 or 48kHz [^2]. The G.711 codec can be considered the lower bound of intelligible audio. It has 8kHz sampling with 8 bits [^3].

The Basys3 has 50 blocks of BRAM (1800Kb total) [^9]. Each block can - among other non-FIFO things - be configured as a `512 x 72` (512 rows of 72 bits = 36Kb) FIFO [^9].

If we use 24 bits. We can have $72/24 = 3$ samples at every row. We can then have $512*50 = 25600$. If we have a sample rate of 44.1kHz, we have a buffer of $25600/44100 = 0.58s$. Typical ranges of reverb is between 0.8 and 4s[^8]. We might have to loop the fifo onto itself. For now we can live with this. If we wanted to utilize the multi line of samples, we could have a setup like

![image](docs/fifo_lines.svg)
**Figure [^fifo_lines]: Samples can be copied to 3 lines for the fifo block. This can be used e.g. as a delay line, a real line, and a processed line - like shown in the figure.**

This will be abstracted away by letting Chisel and Vivado infer what is meant through Chisel's .


## Results

### Determining Length of Audio in Buffer

First we will create an equation with variables representing - bit depth, sample rate, and buffer size.

Let $B$ represent the bit depth, $R$ the sample rate (Hz), and $S$ the buffer size (bits). The length of audio in the buffer $L$ can be calculated as:
$$
L = \frac{S}{R \cdot B}
$$

> [!Note] 
> $$\frac{bits}{\frac{1}{s} \cdot bits} = s$$





| B  (bits) | R    (Hz) | S      (bits) | L (s)  |
| --------- | --------- | ------------- | ------ |
| 24        | 48_000    | 1_800_000     | 15.625 |
| 8         | 8_000     | 1_800_000     | 28.125 |


15 seconds is more than plenty for simple echoes. This shows that Buffer size is not a blocker.


### Making it real-time

#### Baud rate needs much higher
#### Tx 2 stop bits reducing throughput



### Making the gain
### Making the delay
### Making the stutter
### Making the comb filter
### Making the all-pass filter
### Making the Schroeder Reverb






## Discussion


## AI Acknowledgements

### fifo_lines
```
opus 5.5

make a wavedrom table, that shows an audio sample packets coming in (24 bits if it is relevant). It should be copied into 3 new signals. referencing parts of a fifo (because the fifo is 72 bits). Call it FIFO_1, FIFO_2, FIFO_3. then there should be a break, where you say audio processing happened. then you should indicate that FIFO_1 is delayed a couple of samples from FIFO_2. FIFO_3 has some processed audio.
```

### FIFO_DUAL_CLOCK_MACRO typing
```
haiku 5.5 (selected io without types)

can you infer the types and so on
```
created the depth based on the table

### Scala class Hierarchy
```
opus 5.5

I need help setting up my chisel project in a way such that I can just implement the modules kind of separately and easily tie them together

Embedding
[list of goals for the project]
[README.md at commit a53c473cb9ccaeb8c2dba482e3a8d55eda93199b]
[report.md at commit a53c473cb9ccaeb8c2dba482e3a8d55eda93199b]
```

```
Claude sample response:
Every effect extends one small base class, AudioEffect. It has a sample stream in (in) and a sample stream out (out), both ready/valid (Decoupled(SInt)). Controls like delay or gain are extra ports that each effect declares itself. Because every effect has the same stream ports, joining them is one line:
toBytes.in <> AudioEffect.chain(toSamples.out, Seq(gain, delay, comb))
The full pipeline lives in AudioCore:

rx bytes → Queue → BytesToSamples → [effects] → SamplesToBytes → Queue → tx bytes

AudioParams holds the sample width and buffer depth, so changing the bit depth is a one-line change.
```

### How to Write Report and README

Full response can be found at https://github.com/lassenorbjerg/fpga-reverb/blob/8eddd3cf42ab67c650e76f2ee1c1fcf9d2181350/docs/archive/How%20to%20Write%20Report%20and%20README.md

```sh
> cat ~/.claude/CLAUDE.md                         
Be a sparring partner: short answers, show code in chat, don't edit files unless I ask.
```

```
Opus 5.5
I want to completely rewrite the readme. And i want to restructure the report or at least get help with how to structure it for what I want. I want to get an overview and like what should be included and not. README should of course give a brief introduction (written by me, with keypoints to include by you). Give some guidance on how to setup the project. For general how to setup chisel just link to https://github.com/schoeberl/chisel-lab/blob/master/Setup.md It should also describe the setup for the fpga and computer and micriphone. How to setup env, scripts and such. Which commands to run. Setting baud rate on windows. Point to xdc on the naming, that there is a new one for each major feature as well as a new verilog file for each feature. Also help me streamline the file structure in this folder. What should be removed, groupings, new folders, etc. Suggest a place, where I can easily write a description for all the files, which i can link in the readme. For the report I want to know where to put new things. And know what is relevant. I like the idea of having it kinda iterative like the idea with the `### Making it real-time section`. But I need a good outline for the whole report. You shouldn't write any of the actual report. But just how it should be structured. Take a look at `README.md#Predefined goals`. Use that to help guide what should be included in the report. Also make a small general document, but still directed for this report (here you can write freely) about how to write a report. What is important to include, what is not? What should be cited. what is the general writing style of a report. any pointers.
```

#### README Skeleton
```md
# FPGA Reverb
<intro paragraph + setup.svg>

## Status
| Feature | Branch/tag | Verilog | XDC | Works |

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
```

#### Suggested repo layout
```
fpga-reverb/
├── README.md, LICENSE, build.sbt, project/, makefile
├── src/{main,test}/scala/{audio,serial,top,utils}
├── generated/<feature>.v
├── xdc/<feature>.xdc  (+ Basys3_Master.xdc template)
├── scripts/
│   ├── requirements.txt, serial_*.py, uart_debug.py
│   ├── ref_model/volume_control_ref.py
│   └── testdata/
├── report/
│   ├── report.md
│   └── figures/        # setup.svg, fifo_lines.*, fsmd0_1_0.drawio.svg
└── docs/
    ├── files.md        # ← the per-file descriptions
    ├── setup.md        # Windows/Metals/firtool details from the current README
    └── devlog.md       # the 0.1.0 → 0.3.2 notes (raw material for the report)
```

#### files.md structure

```
**`docs/files.md`** is the place to write a description of every file; link it from the README. One table per folder:
```
```md
## src/main/scala/audio
| File | Purpose | Since |
|---|---|---|
| AudioEffect.scala | Base class: Decoupled(SInt) in/out + `chain` helper | 0.3.0 |
| SampleCodec.scala | Bytes ↔ samples | 0.3.0 |
```


## References
[^1]: https://digilent.com/reference/basys3/refmanual

[^2]: https://majormixing.com/audio-sample-rate-and-bit-depth-complete-guide/

[^3]: https://en.wikipedia.org/wiki/G.711

[^4]: https://en.wikipedia.org/wiki/Pulse-code_modulation

[^5]: https://www.analog.com/en/resources/technical-articles/relationship-data-word-size-dynamic-range.html
<!-- should have more bits when processing. just a float thing tho -->

[^6]: https://en.wikipedia.org/wiki/Audio_bit_depth

[^7]: https://ccrma.stanford.edu/~jos/mdft/Pulse_Code_Modulation_PCM.html

<!-- []: https://wiki.sierrahelp.com/index.php/PCM#Integer_Or_Floating_Point -->

<!-- []: https://nandland.com/lesson-15-what-is-a-block-ram-bram/ -->

<!-- []: https://docs.amd.com/v/u/en-US/ug473_7Series_Memory_Resources -->

[^8]: https://www.soundbridge.io/reverb-and-delay-tips-for-cleaner-deeper-mixes

[^9]: https://pcbsync.com/artix-7-35t/

[^fifo_lines]: [fifo_lines](#fifo_lines)

[^setup]: [docs/setup.svg](docs/setup.svg)


[^11]: https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado/vivado-whats-new.html#tabs-de9b056824-item-12e22c06e7-tab

[^12]: https://www.chisel-lang.org/
