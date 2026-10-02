import chisel3._
import chiseltest._
import chiseltest.experimental.expose
import org.scalatest.flatspec.AnyFlatSpec

class BufferedTxDemoExposed(frequ: Int = 10, baud: Int = 10)
    extends BufferedTxDemo(frequ, baud) {
  // Tx prefix is used for the bufferedTx signals
  val exposedTxValid = expose(valid)
  val exposedTxReady = expose(ready)
  val exposedTxBits = expose(bits)
  val exposedTxC = expose(c)
  val exposedTxC_t = expose(c_t)
  val exposedTxHello = expose(hello)
}

class EchoDemoExposed(frequ: Int = 10, baud: Int = 10)
    extends EchoDemo(frequ, baud) {
  val exposedTxBits = expose(uart.tx.io.channel.bits)
  val exposedRxBits = expose(uart.rx.io.channel.bits) //
}

class EchoTestTop(frequ: Int = 10, baud: Int = 10) extends Module {
  val io = IO(new Bundle { val tx = Output(Bool()) })

  val sender = Module(new BufferedTxDemo(frequ, baud)) // dogfooding🤤
  val echo = Module(new EchoDemo(frequ, baud))
  echo.io.rx := sender.io.tx
  io.tx := echo.io.tx

  val senderBits = expose(sender.bits)
  val senderReady = expose(sender.ready)
  val txValid = expose(sender.valid)

  val rxValid = expose(echo.uart.rx.io.channel.valid)
  val rxBits = expose(echo.uart.rx.io.channel.bits)
}

class BufferedTxDemoSpec extends AnyFlatSpec with ChiselScalatestTester {
  "BufferedTxDemo " should "pass" in {
    test(new BufferedTxDemoExposed()) { dut =>
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

class BufferedTxDemoWrite extends AnyFlatSpec with ChiselScalatestTester {
  "BufferedTxDemo " should "write Hello World!" in {
    test(new BufferedTxDemoExposed()) { dut =>
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

class EchoDemoSpec extends AnyFlatSpec with ChiselScalatestTester {
  "EchoDemo" should "echo" in {
    test(new EchoTestTop()) { dut =>
      dut.clock.setTimeout(0)
      val expected = "Hello World!\n"
      var c = 0
      for (ch <- expected) {
        while (!dut.txValid.peekBoolean()) dut.clock.step()
        dut.rxBits.expect(
          ch.toInt.U,
          s"expected '$ch', got '${dut.rxBits.peekInt().toChar}'"
        )
        dut.clock.step()
        c += 1
      }
    }
  }
}
