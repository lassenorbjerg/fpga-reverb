package audio

import chisel3._
import chisel3.util._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import top.AudioCore

import AudioTestingUtils._

class AudioCoreSpec
    extends AnyFlatSpec
    with ChiselScalatestTester
    with Matchers {
  implicit val p: AudioParams =
    AudioParams.hardware
  "AudioCore" should "send out received bytes but with added gain" in {
    test(new AudioCore(p = p)) { dut =>
      dut.io.rx.initSource().setSourceClock(dut.clock)
      dut.io.tx.initSink().setSinkClock(dut.clock)
      val samples = PcmSineSample(freqHz = 2, numSamples = 10)
      val gain = 0
      dut.io.sw.gain.poke(gain)
      for (sample <- samples) {
        val bytes = toBytesLE(sample)
        dut.io.rx.enqueueSeq(bytes.map(_.U))
        val expectedBytes =
          toBytesLE(saturateMock(sample + gain, p.maxAmp)).map(_.U)
        expectedBytes.map(dut.io.tx.expectDequeue(_))
      }
    }
  }
}
