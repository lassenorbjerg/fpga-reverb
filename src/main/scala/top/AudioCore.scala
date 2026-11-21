package top

import audio._
import chisel.lib.uart._
import chisel3._
import chisel3.util._
import utils._

/** Handles what to do with the received UART bytes. And which bytes to send
  * out.
  */
class AudioCore(p: AudioParams = AudioParams.hardware) extends Module {
  val io = IO(new Bundle {
    val rx = Flipped(new UartIO())
    val tx = new UartIO()
    val sw = Input(new Switches)
  })
  implicit val params: AudioParams = p

  val toSamples = Module(new BytesToSample(p))
  val toBytes = Module(new SamplesToBytes(p))

  toSamples.in <> Queue(io.rx, 16)

  val gain: Gain = Module(new Gain)
  gain.switches := io.sw
  gain.in <> toSamples.out
  toBytes.in <> Queue(gain.out, 16)

  toBytes.out <> io.tx
}
