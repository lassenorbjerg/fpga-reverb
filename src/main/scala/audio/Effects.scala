package audio

import chisel3._
import chisel3.util._
import utils._

import util._

class Gain(params: AudioParams) extends AudioEffect(params) {
    val gainIn = switches.gain
    val added = sampleIn + gainIn
    val subbed = sampleIn - gainIn
    val isNeg = sampleIn(sampleIn.getWidth - 1)
    val gainedSample = // check if sample is negative, then we subtract otherwise add
      Mux(isNeg, 
      subbed,
       added)
    processedSample := SampleHelper.saturate(gainedSample)
    processingDone := true.B
}
