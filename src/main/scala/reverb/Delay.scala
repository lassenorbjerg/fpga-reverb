package reverb

import chisel3._
import chisel3.util._
import utils._

class Delay extends Module {
    val io = IO(
        new Bundle {
            val in = Flipped(UInt(Env.sampleWidth.W))
            val out = Output(UInt(Env.sampleWidth.W))
        }
    )
}
