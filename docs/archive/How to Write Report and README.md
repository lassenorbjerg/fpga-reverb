I've read the README, report, scripts, xdc files and the build setup. Below are the README plan, a cleanup of the file structure, a report outline, and the report-writing guide. I haven't changed any files.

---

## 1. README

The idea is that the README answers three things: what this is, how to run it, and where to find more. The dev log and the predefined goals should move out of it (see section 2).

**Points for your intro paragraph:**
- **What it is:** real-time audio effects on a Basys3, written in Chisel.
- **How it works:** mic → PC → UART → FPGA effect chain → UART → PC → speakers. Put `setup.svg` right here.
- **Why:** the course or project context, and your learning goals (Chisel, DSP, FPGA memory).
- **Status:** which effects work today. A small table of Effect | Status | Branch/tag works well.
- A link to the report.

**Skeleton:**
```markdown
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

---

## 2. File structure

**Naming problems I found:**

| Verilog | XDC | Problem |
|---|---|---|
| `EchoDemo.v` | `Basys3_Master_EchoDemo.xdc` | the base names don't match |
| `SerialPort.v` | `serial.xdc` | the base names don't match |
| — | `Basys3_Master_BufferedTxDemo.xdc` | no Verilog file goes with it |
| `echoNew.v` | `echoNew.xdc` | the name doesn't say what feature it is (it's the AudioCore with gain) |

**Rule I'd use:** one feature name used everywhere, e.g. `gain`, giving `object GainMain` → `generated/gain.v` → `xdc/gain.xdc`. You could add a number prefix (`01_echo`, `02_gain`) so the files sort in iteration order.

**Other stale or odd things:**
- The `makefile` defaults to `main ?= "EchoDemo"`, but `top.Top` is the only `App`. Either fix it or delete the makefile.
- `todo`: delete it, or turn it into GitHub issues.
- `docs/archive/`: git history already has these files (`git show 33ac770:README.md`), so I'd delete it.
- `docs/image.png` → rename to something like `test_setup_sketch.png`.
- `scripts/test` and `scripts/lorem` are test fixtures → move them to `scripts/testdata/`.
- `ref_model_py/` → move to `scripts/ref_model/`, so all Python lives in one place with one venv.
- `.gitignore` is about 500 lines of templates (Xcode, Emacs, ISE…). You only need the Scala, sbt, Metals, Vivado and Python parts.
- The report has two image folders (`docs/` and `report/docs/`). Merge them into `report/figures/`.

**Suggested layout:**
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

**`docs/files.md`** is the place to write a description of every file; link it from the README. One table per folder:
```markdown
## src/main/scala/audio
| File | Purpose | Since |
|---|---|---|
| AudioEffect.scala | Base class: Decoupled(SInt) in/out + `chain` helper | 0.3.0 |
| SampleCodec.scala | Bytes ↔ samples | 0.3.0 |
```

---

## 3. Report outline

I'd use a fixed background and system design up front, then one section per iteration, then a cross-cutting evaluation. Each iteration uses the same template, which is basically your 0.1.0 README spec format:

> **Iteration template**
> 1. **Goal:** one line, linked to a predefined goal.
> 2. **Design:** spec (I/O, widths, latency), block diagram/FSMD, resource estimate.
> 3. **Implementation:** only the interesting parts; short snippets.
> 4. **Verification:** which tests, and the reference model.
> 5. **Result:** measured on hardware (plot, numbers).
> 6. **Problems → next step:** what broke, which is why the next iteration exists.

```
Abstract                                  (write last)
1 Introduction
  1.1 Motivation
  1.2 Goals            ← condensed "Predefined goals" as a table
  1.3 Scope/limitations (mono, UART, fixed format)
  1.4 Report structure
2 Background                              (facts from others, cited)
  2.1 Digital audio: PCM, sample rate, bit depth, two's complement, fixed point  ← wk1/2
  2.2 UART framing                                                               ← wk3
  2.3 Basys3/Artix-7 resources: BRAM, DSP slices                                 ← wk1/2
  2.4 DSP effects: delay, comb, all-pass, Schroeder (difference equations + diagrams) ← wk10
3 System design                           (your decisions that apply to everything)
  3.1 Setup (setup.svg), hardware, toolchain
  3.2 Host software + protocol (framing, FF escaping)                            ← wk3
  3.3 Bandwidth budget (baud vs rate × width) and buffer budget (BRAM length)
  3.4 Architecture: AudioCore pipeline, AudioEffect base, ready/valid
  3.5 Verification strategy: chiseltest, Python ref model, loopback              ← wk4
4 Iterations
  4.1 Loopback echo
  4.2 File transfer                                                              ← wk5
  4.3 Making it real-time (baud, stop bits, USB attempt = cancelled, say why)    ← wk9
  4.4 Gain                                                                       ← wk6
  4.5 BRAM buffer + delay                                                        ← wk6/7
  4.6 Comb filter                                                                ← wk8
  4.7 Stutter                                                                    ← wk9
  4.8 All-pass                                                                   ← wk11
  4.9 Schroeder reverb (+ other reverbs considered)                              ← wk12
  4.10 Own effect                                                                ← wk13
5 Evaluation
  - Resource table per iteration (LUT/FF/BRAM/DSP), timing slack
  - Latency end-to-end
  - Output vs reference model (waveform/spectrogram)
  - Goal table: goal | met? | section
6 Discussion  (interpretation, limitations, what you'd change, future work: I2S Pmod, USB audio, header handshake)
7 Conclusion  (answers 1.2 point by point)
References · AI acknowledgements · Appendix (repo + tag/commit, test list)
```

**Where to put new things:**
- A fact from someone else → **2 Background**
- A choice that applies to the whole system → **3 System design**
- Specific to one feature → its **iteration**
- A measurement that compares iterations → **5 Evaluation**
- What a result means, or an opinion → **6 Discussion**
- How to run something → **README**, not the report

**Problems in what you have now:**
- "Determining Length of Audio in Buffer" is a calculation, not a result. Move it to 3.3.
- **The numbers don't match:**
  - The table says 15.625 s, but 1.8M / (48000 × 24) = **1.5625 s**. That breaks "15 s is plenty", because 1.56 s is borderline against the 0.8–4 s reverb range you cite.
  - The FIFO text says 0.58 s because it forgot the ×3 samples per row. It should be 76800 / 44100 ≈ 1.74 s.
  - 50 × 36 Kib is 1,843,200 bits, not 1,800,000.
- **4.3 already has its core calculation:**
  - 48 kHz × 2 B × 10 bits = 960 kbaud, which is more than the 917 kbaud you actually get. So 48 kHz can't keep up.
  - 44.1 kHz needs 882 kbaud, which fits. With 2 stop bits it needs 970 kbaud, which doesn't. That is exactly your "2 stop bits" heading.

---

## 4. How to write this report

**Audience:** an examiner or engineer who knows digital design but has never seen your repo. Explain your project, not what a flip-flop is.

**The thread:** problem → approach → evidence → judgement. Every claim should rest on one of four things: a citation, a calculation, a test, or a measurement. If it rests on none of them, cut it or label it as an assumption.

**Include:**
- Design decisions **and the alternatives you rejected** ("FIFO vs circular buffer because…").
- Negative results, kept short: the cancelled USB attempt, and the distortion caused by baud rate. They show your reasoning.
- Numbers with units, how they were measured, and which config/commit produced them.
- Figures for anything spatial or temporal (block diagrams, FSMDs, waveforms, spectrograms). Every figure gets a caption and is referred to and discussed in the text.
- A reproducibility pointer: repo URL plus a git tag.

**Leave out:**
- Setup instructions (they belong in the README).
- Full code listings. Use 5–15 line snippets and link the rest.
- Your debugging diary ("tried X, then Y, then Z"). Condense it to "X failed because Y, so Z".
- Tool screenshots, unless they show a result (e.g. a utilization report).
- Casual tone ("lol", "kind of", "<3").

**Cite:**
- Primary sources over blogs:
  - Basys3: the Digilent reference manual.
  - BRAM: AMD **UG473**. Replace pcbsync.
  - Clocking: AMD **UG472**.
  - Artix-7 resources: AMD **DS180**.
  - Reverb: Schroeder (1962), "Natural sounding artificial reverberation"; Moorer (1979).
  - DSP: J.O. Smith's CCRMA books, which you already use.
  - Chisel: Bachrach et al. (2012), Schoeberl's *Digital Design with Chisel*.
- Every library you use (`chisel.lib.uart` from ip-contributions).
- Wikipedia and mixing blogs are fine for getting oriented, but find what they cite and cite that instead.
- Don't cite field common knowledge or your own decisions.
- Keep the AI acknowledgements section; it's good practice.

**Style:**
- Present tense for facts and what the design does ("the FIFO holds 512 rows"). Past tense for what you did or measured.
- Pick "I"/"we" or passive voice and stay consistent. For a single author, "I" is fine unless your course says otherwise.
- Define a term at first use, then never change it (host/device, sample/frame).
- Separate Results (what happened) from Discussion (what it means).
- Number your equations and refer to them. Use one unit style throughout (kbit/s, Kib, kHz).
- Write the intro and abstract **last**. The conclusion answers the goals in 1.2 one by one.

**Practical:** footnote-numbered figures in Markdown get painful. Plan to convert at the end with `pandoc report.md --citeproc --bibliography refs.bib -o report.pdf`, or move to LaTeX/Typst once the structure is stable.

---

All of this is in chat only. I can also do the heavy lifting if you want: move and rename the files, write `docs/files.md` and `docs/devlog.md`, fix the makefile, trim `.gitignore`, and put the outline into `report.md` as empty headings.
