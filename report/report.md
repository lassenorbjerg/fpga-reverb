# Utilizing DSP to create audio effects using FPGA

Lasse Nørbjerg s253860

October 2026


## Introduction

## Methods

### Setup

![image](docs/setup.svg)

### Hardware

FPGA board is the Basys3 board$[^1]$.

Any microphone can be used. 


## Results

### Determining Length of Audio in Buffer

First we will create an equation with variables representing - bit depth, sample rate, and buffer size.

Let $B$ represent the bit depth, $R$ the sample rate (Hz), and $S$ the buffer size (bits). The length of audio in the buffer $L$ can be calculated as:
$$
L = \frac{S}{R \cdot B}
$$

> [!Note] 
> $$\frac{bits}{\frac{1}{s} \cdot bits} = s$$

The Basys3 Board has 1800 Kbits of BRAM$[^1]$. Industry records at 24-bit, 44.1 or 48kHz $[^2]$. The G.711 codec can be considered the lower bound of intelligible audio. It has 8kHz sampling with 8 bits $[^3]$.



| B  (bits) | R    (Hz) | S      (bits) | L (s)  |
| --------- | --------- | ------------- | ------ |
| 24        | 48_000    | 1_800_000     | 15.625 |
| 8         | 8_000     | 1_800_000     | 28.125 |


15 seconds is more than plenty for simple echoes. This shows that Buffer size is not a blocker.


## Discussion


## References
$[^1]$ https://digilent.com/reference/basys3/refmanual
$[^2]$ https://majormixing.com/audio-sample-rate-and-bit-depth-complete-guide/
$[^3]$ https://en.wikipedia.org/wiki/G.711
