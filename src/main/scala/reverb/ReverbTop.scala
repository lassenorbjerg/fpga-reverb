package reverb

import chisel3._
import chisel3.util._

class ReverbTop extends Module {

    val io = IO(
        new Bundle {
            val tx = Output(Bool())
            val rx = Input(Bool())
        }
    )

}
