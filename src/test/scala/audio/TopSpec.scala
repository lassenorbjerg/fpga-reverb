package audio

import audio.UartUtils.cyclesPerBit
import chisel3._
import chisel3.util._
import chiseltest._
import chiseltest.formal.past
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import top.Top

import AudioTestingUtils._

class TopSpec extends AnyFlatSpec with ChiselScalatestTester with Matchers {
  implicit val p: AudioParams = AudioParams.test.copy(
    msDelay = 0,
    clockFreq = 32,
    baudRate = 16,
    sampleWidth = 8
  )
  it should "generate waveform by receiving rx and send tx bits" in {
    test(new Top(audioParams = p)).withAnnotations(Seq(WriteVcdAnnotation)) {
      dut =>
        dut.clock.setTimeout(0)
        val sineSample =
          AudioTestingUtils.PcmSineSample(freqHz = 10_000, numSamples = 50)
        sineSample.foreach((byte: Int) => {
          UartUtils
            .uartFrameBits(byte)
            .foreach((b: Int) => {
              dut.io.rxd.poke(b.B)
              dut.clock.step(cyclesPerBit())
            })
        })

        var observedTxChange = false
        var pastTxd = dut.io.txd.peekBoolean()
        for (i <- 0 until p.clockFreq * 50) {
          observedTxChange =
            observedTxChange || dut.io.txd.peekBoolean() != pastTxd
          pastTxd = dut.io.txd.peekBoolean()
          dut.clock.step()

        }
        assert(observedTxChange, "No change in txd observed")

    }
  }
}
