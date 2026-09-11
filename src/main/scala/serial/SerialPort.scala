import chisel3._
import chisel3.util._
import chisel.lib.uart._

/** This is the top level to for the UART output and a test blinking LED.
  */
class SerialPort(frequ: Int, baud: Int = 115200) extends Module {
  val io = IO(new Bundle {
    val tx = Output(Bool())
    val led = Output(Bool())

    // Debug taps used by the tester

  })

  val uart = Module(new BufferedTx(frequ, baud))

  val msg_len = 12.U

  val cntr = RegInit(0.U(4.W))
  val cntr_time = RegInit(0.U(27.W))
  val CNT_MAX = frequ.U

  val hello = VecInit(
    'H'.U,
    'e'.U,
    'l'.U,
    'l'.U,
    'o'.U,
    ' '.U,
    'W'.U,
    'o'.U,
    'r'.U,
    'l'.U,
    'd'.U,
    '!'.U,
    '\n'.U
  )

  val message_sending = cntr =/= msg_len

  uart.io.channel.bits := hello(cntr)
  when(message_sending) {
    when(uart.io.channel.ready) {
      cntr := cntr + 1.U
    }
    io.led := true.B
  }.otherwise {
    when(cntr_time === CNT_MAX) {
      cntr := 0.U
      cntr_time := 0.U
    }.otherwise {
      cntr_time := cntr_time + 1.U
    }
    io.led := false.B
  }

  uart.io.channel.valid := message_sending

  io.tx := uart.io.txd.asBool

  val valid = uart.io.channel.valid
  val ready = uart.io.channel.ready
  val bits = WireDefault(0.U(8.W))
  bits := hello(cntr)
  
  val c = cntr
  val c_t = cntr_time
}

// generate Verilog
object SerialPort extends App {
  emitVerilog(new SerialPort(100000000))
}
