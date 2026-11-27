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
  *   - switches.en must send the sample unaltered to sampleOut
  *   - in and out handshakes must be respected
  * Notes: `StartDoneEffect` extends `AudioEffect`. It implements a Start/Done handshake
  */
abstract class AudioEffect()(implicit params: AudioParams) extends Module {
  implicit val p: AudioParams = params
  val in = IO(Flipped(Decoupled(params.sample)))
  val out = IO(Decoupled(params.sample))
  val switches = IO(Input(new Switches))

}

/** Read AudioEffect docs for additional info.
  * 
  * Contract:
  *   - Begin processing the sample when `start` pulses
  *   - Pulse `done` high when processing is done
  *   - sampleIn will have a valid sample when `start` is high
  *   - sampleOut should be valid when `done` is high
  *   - sampleOut should be sampleIn when switches.en=1
  *
  * @param params
  */
abstract class StartDoneEffect()(implicit params: AudioParams)
    extends AudioEffect() {

  val busy = RegInit(false.B)
  val validReg = RegInit(false.B)
  val sampleOut = Reg(params.sample) // should be set by subclasses

  in.ready := !busy && !validReg // we are not working on a sample and we have been consumed
  out.valid := validReg
  out.bits := sampleOut

  // Subclass relevant fields
  val start = in.fire // triggers subclasses to start processing
  val done = WireDefault(false.B) // subclasses set when done processing
  val sampleIn = in.bits // sampleIn is valid when start is pulsed
  // Subclass relevant fields

  assume(!(start && done), "start and done must not both be high")

  when(start) {
    // we have started work
    busy := true.B
  }.elsewhen(done) {
    // we have finished work and sample has been processed
    busy := false.B
    validReg := true.B
  }.elsewhen(out.fire) {
    // we have been consumed
    validReg := false.B
  }

  /** Macro for generating a start/done handshake. Whenever start is high done
    * gets set high in next cycle.
    *
    * @param processedSample:
    *   Assumed to be valid depending on start
    */
  def oneCycleStartDoneHandshake(processedSample: SInt): Unit = {
    val doneReg = RegNext(RegInit(false.B))

    when(start) {
      doneReg := 1.B
      sampleOut := Mux(switches.en.asBool, processedSample, sampleIn)
    }.otherwise {
      doneReg := 0.B
    }
    done := doneReg
  }
}

object AudioEffect {

  /** Connect src -> effects(0) -> effects(1) -> ... and return the last output.
    * If en=0 the handshaking in the chain will still happen. But the sample
    * returned at the end of the chain will just be the unaltered one
    */
  def chain(
      src: DecoupledIO[SInt],
      effects: Seq[AudioEffect],
      en: Bool
  ): DecoupledIO[SInt] =
    effects.foldLeft(src) { // start with raw src
      (
          stream,
          effect
      ) => // accumulate the effects onto the stream (originally src)
        effect.in <> stream // send the stream into the next effect
        effect.out
    }

  def connect(
      sw: Switches,
      effects: Seq[AudioEffect]
  ): Unit = {
    effects.foreach(_.switches := sw)
  }
}
