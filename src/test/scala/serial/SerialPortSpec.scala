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
    extends EchoDemo(frequ, baud) {}

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
    test(new EchoDemoExposed()) { dut =>
      val bufferedTx = new BufferedTxDemoExposed() // dogfooding🤤
      dut.io.rx.poke(bufferedTx.io.tx)
      dut.clock.setTimeout(0)

      val c = 0
      var hello = bufferedTx.exposedTxHello

      while (bufferedTx.exposedTxBits.peekInt().toChar != '\n') {
        
        if (bufferedTx.exposedTxReady.peekBoolean()) {
          bufferedTx.exposedTxC.expect(c.U)
          val msgEcho =
            s"${hello(c.U).peekInt().toChar} does not match " + dut.io.tx
              .peekInt()
              .toChar
          dut.io.tx.expect(hello(c.U).peekInt().U)  // TODO: should look at the bits
          val msgTx =
            "bufferedTx failed: " + s"${hello(c.U).peekInt().toChar} does not match " + dut.exposedTxBits
              .peekInt()
              .toChar
          bufferedTx.exposedTxBits.expect(hello(c.U).peekInt().U, msgTx)
          print(bufferedTx.exposedTxBits.peekInt().toChar)
          c += 1
        }
        dut.clock.step(1)
      }
    }
  }
}
