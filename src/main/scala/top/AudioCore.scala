package top

import audio._
import chisel.lib.uart._
import chisel3._
import chisel3.util._
import utils._

/**
  * Handles what to do with the received UART bytes. And which bytes to send out.
  *
  */
class AudioCore(p: AudioParams = AudioParams.hardware) extends Module {
  val io = IO(new Bundle {
    val rx = Flipped(new UartIO())
    val tx = new UartIO()
    val sw = Input(new Switches)
  })

  

  val switches = new Switches()

  val toSamples = Module(new BytesToSample(p))
  val toBytes = Module(new SamplesToBytes(p))

  toSamples.in <> Queue(io.rx, p.bytesPerSample)  // queue to give a little headroom

  val sample: DecoupledIO[SInt] = toSamples.out

  val gain = Module(new Gain(p))
  gain.switches := io.sw

  toBytes.in <> AudioEffect.chain(src=sample, effects=Seq(gain))
  toBytes.out <> io.tx
}
