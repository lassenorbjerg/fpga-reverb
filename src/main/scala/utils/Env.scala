package utils

import chisel3._
import chisel3.util._

class Switches extends Bundle {
  // The first field declared ends up on the MSBs
  val en = Input(UInt(1.W))
  val rest = Input(UInt(7.W))
  val gain = Input(SInt(8.W))
}

object SwitchesConfig {

  def T_ = UInt(Board.amntSwitches.W)

  val gainT = SInt(Env.gainWidth.W) // sw[7:0]

  val regions = List(gainT)

  // val numOccupied: Int = regions.map(_.getWidth).reduceLeft(_ + _)
  // val restT = UInt((Board.amntSwitches - numOccupied).W)
  val restT = UInt(8.W)
}

object Board {
  val clockFreq: Int = 100_000_000 // 100MHz
  val amntSwitches: Int = 16

}


/**
  * Defaults for widths. As well as useful constants.
  */
object Env {
  val sampleWidth: Int = 16 // bits per PCM sample
  val gainWidth: Int = 8  // SInt

  val BaudRate: Int = 921_600 // bits/s
  val sampleRate: Int = 44_100 // Hz

  val msDelay: Int = 20
}
