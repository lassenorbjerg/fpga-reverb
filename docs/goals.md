# Predefined goals

# Predefined goals

## week 1/2
### Research
#### Research audio formats
- sample rate
- bit depth
- sample data type (how to handle floats)
- Standards
    - What data is needed?
#### Understand how the BRAM works on the board
- How is bram different?
- Is it just flip-flops?
- is it volatile?
- Note how big for basys3
- How do you write to it?
    - Is it a vivado config?
    - xdc?
- What happens if it gets filled?
- Are there addresses?
    - Are they linear?
        - Guess it is still <ins>RA</ins>M lol
- Does it support instructions?

> It supports FIFO config <3<3<3

#### Calculate the max length of samples that can be saved in BRAM, given sample rate and bit depth 
- Find upper bound (no headers just raw audio)
- What should be saved in BRAM?
- Can we take shortcuts
    - Every other sample, etc.


## week 3
### Sending/Receiving audio

#### Determine appropriate protocol for sending Audio serially
- UART
- Headers
- Allowed configurability
    - Support only one format?

#### Script for sending audio serially
- Existing libraries?
- Should be able to choose where it sends the data
    - Useful for testing, can be sent to an internal bus, that can be listened to

## week 4
#### Set up Testbench
- Contained deterministic tests
- 
#### Set up Simulator
- Send/receive data from pc
- 
## week 5
### Playing Audio

#### Input audio from file into the FPGA and hear undistorted playback (based on which is easier, microphone input might be done before supporting file input)
- Should it be same protocol sending it back?

## week 6
### Modifying audio
#### Change volume based on switch input 
- 



#### Create a buffer using the BRAM
- FIFO?
    - Dynamic?
- 
## week 7
#### Create a very simple delay - output the buffer after x amount of time
- 
## week 8

#### Create a comb filter - output the input along with the delayed buffer
- 
## week 9
#### Create a "stuttering" effect - cut playback every x amount of time
- 

#### Input real-time audio from microphone into the FPGA and hear undistorted playback 
- 
## week 10
#### Understand digital all-pass filters 
- 
## week 11
#### Make an all-pass filter
- 
## week 12
#### Make a Schroeder reverb
- 

#### Look into other types of reverb and see how feasible they would be
- 
## week 13
#### Experiment and try to make own audio effect
- 


