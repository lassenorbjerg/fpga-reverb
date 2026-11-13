package audio

import chisel3._
import chisel3.util._
import utils.Env

/* Contract for all audio effects: a stream of samples in, a stream of
  * samples out, ready/valid on both sides. One input sample gives exactly one
  * output sample.
  *
  * Controls (delay, gain, ...) are extra ports declared in the subclass with
  * their own IO(...), so the stream ports stay identical across effects and
  * `AudioEffect.chain` can wire any list of them together.
  *
  * Rules that keep effects composable:
  *  - out.valid may depend on in.valid, never on out.ready.
  *  - Never drop or invent samples; stall with ready instead.
  */
abstract class AudioEffect(params: AudioParams) extends Module {
  val in = IO(Flipped(Decoupled(params.sample)))
  val out = IO(Decoupled(params.sample))
}

object AudioEffect {
  /** Connect src -> effects(0) -> effects(1) -> ... and return the last output. */
  def chain(src: DecoupledIO[SInt], effects: Seq[AudioEffect]): DecoupledIO[SInt] =
    effects.foldLeft(src) { (stream, effect) =>
      effect.in <> stream
      effect.out
    }
}
