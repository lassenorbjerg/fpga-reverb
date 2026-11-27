package top

import audio._
import chisel.lib.uart._
import chisel3._
import chisel3.util._
import utils.SampleHelper.msToSampleDelay
import utils._

/** Handles what to do with the received UART bytes. And which bytes to send
  * out.
  */
class AudioCore(p: AudioParams = AudioParams.hardware)
    extends Module {
  val io = IO(new Bundle {
    val rx = Flipped(new UartIO())
    val tx = new UartIO()
    val sw = Input(new Switches)
  })
  implicit val params: AudioParams = p
  val en = io.sw.en.asBool || p.enAlwaysHigh.B

  val toSamples = Module(new BytesToSample(p))
  val toBytes = Module(new SamplesToBytes(p))

  toSamples.in <> Queue(io.rx, 16)
  val samples = toSamples.out

  val delaySamples: Int = msToSampleDelay(p.msDelay) // runtime sanity check
  val effect1: Delay = Module(new Delay(delaySamples))

  val effects: Seq[AudioEffect] = Seq(
    effect1
  )

  AudioEffect.connect(io.sw, effects)
  val processedSample = AudioEffect.chain(toSamples.out, effects, en)

  toBytes.in <> processedSample
  toBytes.out <> io.tx
}
