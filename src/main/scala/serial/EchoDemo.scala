import chisel3._
import chisel3.util._
import chisel.lib.uart._

/** This is the top level to for the UART output and a test blinking LED.
  */
class EchoDemo(frequ: Int, baud: Int = 115200) extends Module {
  val io = IO(new Bundle {
    val tx = Output(Bool())
    val rx = Input(Bool())
  })

  val uart = Module(new Echo(frequ, baud))


  io.tx := uart.io.txd.asBool  // NOTE: Notice device := host
  uart.io.rxd := io.rx.asUInt  // NOTE: Notice host := device

  // For testing
}

// generate Verilog
object EchoDemo extends App {
  emitVerilog(new EchoDemo(100000000,921_600))
}
