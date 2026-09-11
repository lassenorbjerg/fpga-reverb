import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest.experimental.expose

class SerialPortExposed(frequ: Int = 10, baud: Int = 10)
    extends SerialPort(frequ, baud) {
  val exposedValid = expose(valid)
  val exposedReady = expose(ready)
  val exposedBits = expose(bits)
  val exposedC = expose(c)
  val exposedC_t = expose(c_t)

}

class SerialPortSpec extends AnyFlatSpec with ChiselScalatestTester {
  "SerialPort " should "pass" in {
    test(new SerialPortExposed()) { dut =>
      dut.clock.setTimeout(0)
      println(dut.exposedReady.peek())
      while (dut.exposedBits.peekInt().toChar != '\n') {
        if (dut.exposedReady.peekBoolean()) {
          println(
            dut.exposedC.peek(),
            dut.exposedC_t.peek(),
            dut.exposedBits.peekInt().toChar,
            dut.exposedReady.peek(),
            dut.exposedValid.peek()
          )
        }
        dut.clock.step(1)
      }
      for (value <- 0 until 12) {
        println(
          dut.exposedC.peek(),
          dut.exposedC_t.peek(),
          dut.exposedBits.peekInt().toChar,
          dut.exposedReady.peek(),
          dut.exposedValid.peek()
        )
        dut.clock.step(1)
      }

    }
  }
}
