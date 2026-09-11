import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec


class SerialPortSpec extends AnyFlatSpec with ChiselScalatestTester {
  "SerialPort " should "pass" in {
    test(new SerialPort(10)) { dut =>
      dut.clock.setTimeout(0)
      println(dut.io.ready.peek())
      while (dut.io.bits.peekInt().toChar != '\n') {
        if (dut.io.ready.peekBoolean()) {
            println(dut.io.c.peek(),dut.io.c_t.peek(),dut.io.bits.peekInt().toChar, dut.io.ready.peek(), dut.io.valid.peek())
        }
        dut.clock.step(1)
     }
     for (value <- 0 until 12) {
        println(dut.io.c.peek(),dut.io.c_t.peek(),dut.io.bits.peekInt().toChar, dut.io.ready.peek(), dut.io.valid.peek())
        dut.clock.step(1)
     }

    }
  }
}
