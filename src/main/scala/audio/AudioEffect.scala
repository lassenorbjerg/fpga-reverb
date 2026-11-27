package audio

import chisel3._
import chisel3.util._
import chiseltest.formal.past
import utils._

/** Contract for audio effects: stream of samples in. Stream of samples out.
  * ready/valid on both sides. One input sample gives exactly one output sample.
  *
  * Controls (delay, gain, ...) are defined with `switches`.
  *
  * `AudioEffect.chain` can wire any list of effects together.
  *
  * Rules:
  *   - out.valid may depend on in.valid, never on out.ready.
  *   - Stall with ready instead of dropping samples.
  * Contract:
  *   - derived classes set validReg and out.bits
  *   - when validReg=1 && out.ready=1 set validReg=0
  *   - out.bits cannot be set while validReg=1
  *   - sampleIn can be assumed to always have a valid sample
  *     - in the start it will be 0
  */
abstract class AudioEffect()(implicit params: AudioParams) extends Module {
  implicit val p: AudioParams = params
  val in = IO(Flipped(Decoupled(params.sample)))
  val out = IO(Decoupled(params.sample))
  val switches = IO(Input(new Switches))

  val sampleIn = RegInit(0.S(params.sampleWidth.W))

  val validReg = RegInit(false.B)  // out.valid
  val readyReg = RegInit(false.B)  // in.ready
  val nValidReg = !validReg

  when(in.fire) {
    sampleIn := in.bits
    readyReg := false.B
  }.otherwise {
    readyReg := nValidReg  // we stall with ready while out has not been consumed
  }

  out.valid := validReg
  in.ready := readyReg
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
