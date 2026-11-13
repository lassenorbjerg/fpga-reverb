package utils

import chisel3._
import chisel3.util._

class Switches extends Bundle {
  // The first field declared ends up on the MSBs
  val placeHolder2 = UInt(2.W) // sw[10:9]
  val placeHolder = UInt(1.W) // sw[8]
  val gain = UInt(8.W) // sw[7:0]
}

object Switches {

  def T_ = UInt(Board.amntSwitches.W)

  def apply(raw: UInt): Switches = {
    val w = (new Switches).getWidth
    require(w <= Board.amntSwitches, "Too many switches defined.")
    raw(w - 1, 0).asTypeOf(new Switches)
  }
}

object Board {
  val clockFreq: Int = 100_000_000 // 100MHz
  val amntSwitches: Int = 16

}

object Env {
  val sampleWidth: Int = 16 // bits per PCM sample
  val delayDepth: Int = 4 // How many samples each delay line can hold

  val BaudRate: Int = 921_600
  val sampleRate: Int = 48_000 // Hz
}
