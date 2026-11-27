package audio

import chisel3._
import chisel3.util._
import utils.SampleHelper.saturate
import utils._
import chisel.lib.fifo._

import util._

/** Used as a baseline of how an effect should behave
  *
  * @param threshold
  * @param params
  */
class SaturateAddGain(threshold: Option[Int] = None)(implicit
    params: AudioParams
) extends StartDoneEffect() {
  val gainIn = switches.gain

  val isNeg = sampleIn(sampleIn.getWidth - 1)
  val gainedSample = // check if sample is negative, then we subtract otherwise add
    // Use widening arithmetic
    Mux(isNeg, sampleIn -& gainIn, sampleIn +& gainIn)

  val saturatedSample = saturate(gainedSample, threshold)

  oneCycleStartDoneHandshake(saturatedSample)
}

/** Used as a baseline of how an effect should behave
  *
  * @param threshold
  * @param params
  */
class Saturate(threshold: Option[Int] = None)(implicit params: AudioParams)
    extends StartDoneEffect() {

  val saturatedSample = saturate(sampleIn, threshold)

  oneCycleStartDoneHandshake(saturatedSample)
}

/** Will consume inputs until FIFO has been filled up. When it is full `out`
  * will become valid.
  *
  * @param delaySamples:
  *   How many samples to delay by
  * @param params
  */
class Delay(delaySamples: Int)(implicit params: AudioParams)
    extends AudioEffect() {
  val mem = Module(new MemFifo(params.sample, delaySamples))
  mem.io.enq <> in
  out <> mem.io.deq
}

class Gain(threshold: Option[Int])(implicit params: AudioParams)
    extends StartDoneEffect() {
  
  val gainedSample = WireDefault(0.S(params.sampleWidth.W))
  val processedSample = WireDefault(0.S(params.sampleWidth.W))
  gainedSample := sampleIn * switches.gain

  if (threshold.isDefined) {
    processedSample := saturate(gainedSample, threshold)
  } else {
    processedSample := gainedSample
  }
  
  oneCycleStartDoneHandshake(processedSample)
}
