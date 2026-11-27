package audio

import chisel3._
import chisel3.util._
import utils.SampleHelper.saturate
import utils._

import util._

/**
  * Used as a baseline of how an effect should behave
  *
  * @param threshold
  * @param params
  */
class Saturate(threshold: Option[Int] = None)(implicit params: AudioParams)
    extends AudioEffect() {
  val gainIn = switches.gain

  val isNeg = sampleIn(sampleIn.getWidth - 1)
  val gainedSample = // check if sample is negative, then we subtract otherwise add
    // Use widening arithmetic
    Mux(isNeg, sampleIn -& gainIn, sampleIn +& gainIn)

  val saturatedSample = saturate(gainedSample, threshold)

  oneCycleStartDoneHandshake(saturatedSample)
}


/**
  * Will output 0.S until FIFO has been filled up. Note that `done` will still be set
  * while it is being filled up.
  *
  * @param delaySamples: How many samples to delay by
  * @param params
  */
class Delay(delaySamples: Int)(implicit params: AudioParams) extends AudioEffect() {
    // in=sampleIn, n=delaySamples, resetData=0.S, en=start
    val shiftReg = ShiftRegister(sampleIn, delaySamples, 0.S, start)

    oneCycleStartDoneHandshake(shiftReg)
}
