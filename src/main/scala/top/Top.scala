package top

import audio._
import chisel.lib.uart._
import chisel3._
import chisel3.util._
import utils._

/** Reads UART bits and links it to AudioCore as bytes
  */
class Top(audioParams: AudioParams) extends Module {
  val io = IO(new Bundle {
    val rxd = Input(Bool())
    val txd = Output(Bool())
    val sw = Input(Switches.T_)
  })

  val rx = Module(
    new Rx(
      frequency = Board.clockFreq,
      baudRate = Env.BaudRate
    )
  )
  rx.io.rxd := io.rxd

  val tx = Module(
    new Tx(
      frequency = Board.clockFreq,
      baudRate = Env.BaudRate
    )
  )
  io.txd := tx.io.txd

  val core = Module(new AudioCore(p = audioParams))
  core.io.sw := io.sw

  core.io.rx :<>= rx.io.channel // consumer :<>= producer
  tx.io.channel :<>= core.io.tx // consumer :<>= producer
}

object Top extends App {

  val audioParams = AudioParams.hardware

  VerilogGen(new Top(audioParams = audioParams), "echoNew", outDir = "generated")
}
