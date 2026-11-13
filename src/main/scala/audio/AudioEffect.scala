package audio

import chisel3._
import chisel3.util._
import utils._

/**
 *  Contract for all audio effects: a stream of samples in, a stream of
 * samples out, ready/valid on both sides. One input sample gives exactly one
 * output sample.
 *
 * Controls (delay, gain, ...) are extra ports declared in the subclass with
 * their own IO(...), so the stream ports stay identical across effects and
 * `AudioEffect.chain` can wire any list of them together.
 *
 * Rules:
 *  - out.valid may depend on in.valid, never on out.ready.
 *  - Never drop or invent samples; stall with ready instead.
 *
 * Subclass contract:
 * - Override effect method
 *   * See contract for `effect()`
 *
 */
abstract class AudioEffect(params: AudioParams) extends Module {
  val in = IO(Flipped(Decoupled(params.sample)))
  val out = IO(Decoupled(params.sample))
  val switches = IO(Input(new Switches))

  val sampleIn = RegInit(0.S(params.sampleWidth.W))
  val sampleOut = RegInit(0.S(params.sampleWidth.W))
  val emptyIn = RegInit(true.B) // if in buffer is empty.
  val fullOut = RegInit(
    false.B
  ) // we want to be able to control valid after out has been consumed.

  in.ready := emptyIn // if empty: we have consumed our sample. we are ready for another one.

  val processedSample = Wire(SInt(params.sampleWidth.W)) // Should be set in child classes
  val processingDone = Wire(Bool()) // Should be set in child classes
  effect()  // run effect. Sets processedSample and processingDone wires

  out.valid := processingDone && fullOut // ready to be consumed. And we have not been consumed
  out.bits := processedSample

  sampleOut := Mux(processingDone, processedSample, sampleOut)

  when(in.fire) { // we want to save the sample while waiting for a new one
    sampleIn := in.bits
    emptyIn := false.B
  }.elsewhen(out.fire) {
    emptyIn := true.B // both in and out has consumed. We are ready for new data
    fullOut := false.B // we no longer have output to be consumed.
  }

  /** This should do w/e the effect is. In this it just pumps out the input.
    * Contract:
    * - `processedSample` wire SInt
    *   * Set to the processed sample
    * - `processingDone` wire Bool
    *   * Is processedSample valid?
    *
    * @return
    */
  def effect(): Unit = {
    processedSample := sampleIn
    processingDone := true.B
  }
}

object AudioEffect {

  /** Connect src -> effects(0) -> effects(1) -> ... and return the last output.
    */
  def chain(
      src: DecoupledIO[SInt],
      effects: Seq[AudioEffect]
  ): DecoupledIO[SInt] =
    effects.foldLeft(src) { // start with raw src
      (
          stream,
          effect
      ) => // accumulate the effects onto the stream (originally src)
        effect.in <> stream // send the stream into the next effect
        effect.out // return the output of the effect
    }
}
