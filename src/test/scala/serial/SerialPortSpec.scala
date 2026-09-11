import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest.experimental.expose

class SerialPortExposed(frequ: Int = 10, baud: Int = 10)
    extends SerialPort(frequ, baud) {
  val exposedUart = expose(uart)
  val exposedHello = expose(hello)
  val exposedC = expose(cntr)
  val exposedC_t = expose(cntr_time)

}

class SerialPortSpec extends AnyFlatSpec with ChiselScalatestTester {
  "SerialPort " should "pass" in {
    test(new SerialPortExposed()) { dut =>
      dut.clock.setTimeout(0)
      println(dut.exposedUart.io.channel.ready.peek())
      while (dut.exposedUart.io.channel.bits.peekInt().toChar != '\n') {
        if (dut.exposedUart.io.channel.ready.peekBoolean()) {
          println(
            dut.exposedC.peek(),
            dut.exposedC_t.peek(),
            dut.exposedUart.io.channel.bits.peekInt().toChar,
            dut.exposedUart.io.channel.ready.peek(),
            dut.exposedUart.io.channel.valid.peek()
          )
        }
        dut.clock.step(1)
      }
      for (value <- 0 until 12) {
        println(
          dut.exposedC.peek(),
          dut.exposedC_t.peek(),
          dut.exposedUart.io.channel.bits.peekInt().toChar,
          dut.exposedUart.io.channel.ready.peek(),
          dut.exposedUart.io.channel.valid.peek()
        )
        dut.clock.step(1)
      }

    }
  }
}
