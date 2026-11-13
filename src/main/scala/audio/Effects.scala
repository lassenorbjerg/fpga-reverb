package audio

import chisel3._
import chisel3.util._
import utils._

import util._

class Gain(params: AudioParams) extends AudioEffect(params) {
  val gainIn = IO(Input(SwitchesConfig.gainT)) // SInt

  override def effect(): (SInt, Bool) = {
    val gainedSample = // check if sample is negative, then we subtract otherwise add
      Mux(sampleIn(sampleIn.getWidth - 1), sampleIn - gainIn, sampleIn + gainIn)
    (SampleHelper.saturate(gainedSample), true.B)
  }
}
