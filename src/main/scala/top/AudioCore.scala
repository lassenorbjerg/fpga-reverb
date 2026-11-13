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
    val sw = Input(Switches.T_)
  })

  val toSamples = Module(new BytesToSample(p))
  val toBytes = Module(new SamplesToBytes(p))

  toSamples.in <> Queue(io.rx, 16)

  // Should just echo out the input
  toBytes.in <> toSamples.out
  toBytes.out <> io.tx
}
