// Written by Opus 5.5
package serial

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers

class UartTxSpec extends AnyFlatSpec with ChiselScalatestTester with Matchers {

  /** Offers `bytes` back to back as fast as the transmitter accepts them and
    * records the txd line every clock cycle.
    */
  def capture(dut: UartTx, bytes: Seq[Int], cycles: Int): Seq[Int] = {
    var next = 0
    for (_ <- 0 until cycles) yield {
      val offering = next < bytes.length
      dut.io.channel.valid.poke(offering.B)
      dut.io.channel.bits.poke((if (offering) bytes(next) else 0).U)
      val fire = offering && dut.io.channel.ready.peek().litToBoolean
      val bit = dut.io.txd.peek().litValue.toInt
      dut.clock.step()
      if (fire) next += 1
      bit
    }
  }

  /** Software 8N1 receiver: finds each start edge, samples every bit at its
    * nominal centre and checks the start and stop bits.
    * Returns (start cycle, byte) per frame.
    */
  def decode(line: Seq[Int], period: Double): Seq[(Int, Int)] = {
    val frames = Seq.newBuilder[(Int, Int)]
    var i = 1
    while (i < line.length) {
      if (line(i - 1) == 1 && line(i) == 0) {
        def bitAt(k: Int) = line((i + period * (k + 0.5)).toInt)
        withClue(s"start bit of frame at cycle $i: ") { bitAt(0) shouldBe 0 }
        withClue(s"stop bit of frame at cycle $i: ") { bitAt(9) shouldBe 1 }
        val byte = (1 to 8).map(k => bitAt(k) << (k - 1)).sum
        frames += ((i, byte))
        i = (i + period * 9.5).toInt // resume searching from the middle of the stop bit
      } else i += 1
    }
    frames.result()
  }

  // (clock, baud): an exact divider, a fractional one, and the real board setting.
  for ((frequency, baud) <- Seq((1000, 100), (1085, 100), (100_000_000, 921_600))) {
    val period = frequency.toDouble / baud
    val bytes = Seq(0x00, 0xff, 0x55, 0xaa, 0x01, 0x80, 0x0e, 0x0f, 0xdf, 0xbf) ++ (0 until 22)

    s"UartTx ($frequency Hz, $baud baud)" should "send 8N1 frames back to back at the exact baud" in {
      test(new UartTx(frequency, baud)) { dut =>
        dut.clock.setTimeout(0)
        val cycles = ((bytes.length + 1) * 10 * period).toInt
        val frames = decode(capture(dut, bytes, cycles), period)

        frames.map(_._2) shouldBe bytes

        // Each frame starts 10 bit-times after the previous one: one stop bit, no idle gap.
        // The bit timer may round a single bit by one clock, but must not drift.
        val starts = frames.map(_._1)
        for ((start, n) <- starts.zipWithIndex) {
          withClue(s"frame $n starts at cycle $start: ") {
            (start - starts.head).toDouble shouldBe (n * 10 * period) +- 1.0
          }
        }
      }
    }
  }
}
