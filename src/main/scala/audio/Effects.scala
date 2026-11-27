package audio

import chisel3._
import chisel3.util._
import utils._

import util._
import utils.SampleHelper.saturate

class Gain()(implicit params: AudioParams) extends AudioEffect() {
    val gainIn = switches.gain
    val processedSample = Reg(p.sample)
    
    val isNeg = sampleIn(sampleIn.getWidth - 1)
    val gainedSample = // check if sample is negative, then we subtract otherwise add
    // Use widening arithmetic
      Mux(isNeg, sampleIn -& gainIn,sampleIn +& gainIn)

    when(validReg && out.ready) {
        validReg := 0.B
    }.otherwise {
        processedSample := saturate(gainedSample)
        validReg := 1.B
    }

    out.bits := processedSample

}
