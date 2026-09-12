import chisel3._
import chiseltest._
import chiseltest.experimental.expose
import org.scalatest.flatspec.AnyFlatSpec

class SerialPortExposed(frequ: Int = 10, baud: Int = 10)
    extends SerialPort(frequ, baud) {
  val exposedValid = expose(valid)
  val exposedReady = expose(ready)
  val exposedBits = expose(bits)
  val exposedC = expose(c)
  val exposedC_t = expose(c_t)
  val exposedHello = expose(hello)

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

// when receiver is ready
// when sender has valid data
//

class SerialPortWrite extends AnyFlatSpec with ChiselScalatestTester {
  "SerialPort " should "write Hello World!" in {
    test(new SerialPortExposed()) { dut =>
      dut.clock.setTimeout(0)
      dut.exposedBits.expect('H'.U)
      while (!dut.exposedReady.peekBoolean()) {
        dut.exposedBits.expect('H'.U)
        dut.clock.step(1)
      }
      dut.exposedValid.expect(true.B)
      dut.exposedBits.expect('H'.U)

      var c = 0
      var hello = dut.exposedHello

      while (dut.exposedBits.peekInt().toChar != '\n') {
        if (dut.exposedReady.peekBoolean()) {
          dut.exposedC.expect(c.U)
          val msg =
            s"${hello(c.U).peekInt().toChar} does not match " + dut.exposedBits
              .peekInt()
              .toChar
          dut.exposedBits.expect(hello(c.U).peekInt().U, msg)
          print(dut.exposedBits.peekInt().toChar)
          c += 1
        }
        dut.clock.step(1)
      }
    }
  }
}

class SerialPortRead extends AnyFlatSpec with ChiselScalatestTester {
  "SerialPort" should "read" in {
    test(new SerialPortExposed()) { dut =>
      dut.clock.setTimeout(0)
      
    }
  }
}
