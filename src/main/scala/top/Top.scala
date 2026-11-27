package top

import audio._
import chisel.lib.uart._
import chisel3._
import chisel3.util._
import serial.UartTx
import utils._

/** Reads UART bits and links it to AudioCore as bytes
  */
class Top(audioParams: AudioParams) extends Module {
  val io = IO(new Bundle {
    val rxd = Input(Bool())
    val txd = Output(Bool())
    val sw = Input(SwitchesConfig.T_)
  })

  val rx = Module(
    new Rx(
      frequency = audioParams.clockFreq,
      baudRate = audioParams.baudRate
    )
  )
  rx.io.rxd := io.rxd

  val tx = Module(
    new UartTx(
      frequency = audioParams.clockFreq,
      baudRate = audioParams.baudRate
    )
  )
  io.txd := tx.io.txd

  val core = Module(new AudioCore(p = audioParams))
  core.io.sw := io.sw.asTypeOf(new Switches)

  core.io.rx <> Queue(rx.io.channel, 64)
  tx.io.channel :<>= core.io.tx // consumer :<>= producer
}

object Top extends App {

  val audioParams = AudioParams.hardware

  VerilogGen(
    new Top(audioParams = audioParams),
    "delay",
    outDir = "generated"
  )
}
