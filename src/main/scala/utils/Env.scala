package utils

import chisel3._
import chisel3.util._

class Switches extends Bundle {
  // The first field declared ends up on the MSBs
  val rest = SwitchesConfig.restT
  val gain = SwitchesConfig.gainT
}

object SwitchesConfig {

  def T_ = UInt(Board.amntSwitches.W)

  val gainT = SInt(8.W) // sw[7:0]

  val regions = List(gainT)

  val numOccupied: Int = regions.map(_.getWidth).reduceLeft(_ + _)
  val restT = UInt((Board.amntSwitches - numOccupied).W)
}

object Board {
  val clockFreq: Int = 100_000_000 // 100MHz
  val amntSwitches: Int = 16

}

object Env {
  val sampleWidth: Int = 16 // bits per PCM sample
  val delayDepth: Int = 4 // How many samples each delay line can hold
  val maxSampleVal: Int = 2 << (sampleWidth - 1) - 1  // 2^(w-1) - 1
  val minSampleVal: Int = -2 << (sampleWidth - 1)     // -2^(w-1)
  val maxAmp: Int = maxSampleVal * 3/4                // We do not want to break our ears o_O

  val BaudRate: Int = 921_600 // bits/s
  val sampleRate: Int = 48_000 // Hz
}
