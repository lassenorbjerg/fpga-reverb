import chisel3._
import chiseltest._
import chiseltest.experimental.expose
import org.scalatest.flatspec.AnyFlatSpec

class SerialPortExposed(frequ: Int = 10, baud: Int = 10)
    extends SerialPort(frequ, baud) {
      // Tx prefix is used for the bufferedTx signals
      val exposedTxValid = expose(valid)
      val exposedTxReady = expose(ready)
      val exposedTxBits = expose(bits)
      val exposedTxC = expose(c)
      val exposedTxC_t = expose(c_t)
      val exposedTxHello = expose(hello)

      // FIXME:
      // val exposedRxValid = expose(io.rx.valid)
      // val exposedRxReady = expose(io.rx.ready)
      // val exposedRxBits = expose(io.rx.bits)

}

class SerialPortSpec extends AnyFlatSpec with ChiselScalatestTester {
  "SerialPort " should "pass" in {
    test(new SerialPortExposed()) { dut =>
      dut.clock.setTimeout(0)
      println(dut.exposedTxReady.peek())
      while (dut.exposedTxBits.peekInt().toChar != '\n') {
        if (dut.exposedTxReady.peekBoolean()) {
          println(
            dut.exposedTxC.peek(),
            dut.exposedTxC_t.peek(),
            dut.exposedTxBits.peekInt().toChar,
            dut.exposedTxReady.peek(),
            dut.exposedTxValid.peek()
          )
        }
        dut.clock.step(1)
      }
      for (value <- 0 until 12) {
        println(
          dut.exposedTxC.peek(),
          dut.exposedTxC_t.peek(),
          dut.exposedTxBits.peekInt().toChar,
          dut.exposedTxReady.peek(),
          dut.exposedTxValid.peek()
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
      dut.exposedTxBits.expect('H'.U)
      while (!dut.exposedTxReady.peekBoolean()) {
        dut.exposedTxBits.expect('H'.U)
        dut.clock.step(1)
      }
      dut.exposedTxValid.expect(true.B)
      dut.exposedTxBits.expect('H'.U)

      var c = 0
      var hello = dut.exposedTxHello

      while (dut.exposedTxBits.peekInt().toChar != '\n') {
        if (dut.exposedTxReady.peekBoolean()) {
          dut.exposedTxC.expect(c.U)
          val msg =
            s"${hello(c.U).peekInt().toChar} does not match " + dut.exposedTxBits
              .peekInt()
              .toChar
          dut.exposedTxBits.expect(hello(c.U).peekInt().U, msg)
          print(dut.exposedTxBits.peekInt().toChar)
          c += 1
        }
        dut.clock.step(1)
      }
    }
  }
}

// class SerialPortRead extends AnyFlatSpec with ChiselScalatestTester {
//   "SerialPort" should "read" in {
//     test(new SerialPortExposed()) { dut =>
//       dut.clock.setTimeout(0)
//       dut.exposedRxValid.peek()
//       dut.exposedRxReady.peek()
//       dut.exposedRxBits.peek()
//     }
//   }
// }
