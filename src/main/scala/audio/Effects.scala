package audio

import chisel3._
import chisel3.util._
import utils._

import util._

class Gain(params: AudioParams) extends AudioEffect(params) {
  val gainIn = IO(Input(SwitchesConfig.gainT)) // SInt

  val gainedSample = 

  override def effect(): (SInt, Bool) = {
    SampleHelperSInt.saturate()
  }
}
