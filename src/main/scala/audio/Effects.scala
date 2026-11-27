package audio

import chisel3._
import chisel3.util._
import utils.SampleHelper.saturate
import utils._

import util._

class Saturate(threshold: Option[Int] = None)(implicit params: AudioParams)
    extends AudioEffect() {
  val gainIn = switches.gain

  val isNeg = sampleIn(sampleIn.getWidth - 1)
  val gainedSample = // check if sample is negative, then we subtract otherwise add
    // Use widening arithmetic
    Mux(isNeg, sampleIn -& gainIn, sampleIn +& gainIn)

  val saturatedSample = saturate(gainedSample, threshold)
  // we are not allowed to set start and done in same cycle.
  //   So we delay it
  val doneReg = RegInit(false.B)

  when(start) {
    doneReg := 1.B
    sampleOut := saturatedSample
  }.otherwise {
    done := 0.B
  }
  done := doneReg
}
