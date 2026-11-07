package audio

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers

import AudioTestingUtils._

class SampleCodecSpec
    extends AnyFlatSpec
    with ChiselScalatestTester
    with Matchers {

  for (width <- Seq(8, 16, 24)) {

    implicit val p: AudioParams =
      AudioParams(sampleWidth = width, sampleRate = 64)
    val sineSamples = // Ensure we get two full cycles  // period = sampleRate / freq
      PcmSineSample(freqHz = p.sampleRate / 4, numSamples = p.sampleRate / 2)

    s"BytesToSample ($width-bit)" should "reassemble bytes" in {
      test(new BytesToSample(p = p)) { dut =>
        dut.in.initSource().setSourceClock(dut.clock)
        dut.out.initSink().setSinkClock(dut.clock)

        for (sample <- sineSamples) {
          dut.in.enqueueSeq(
            toBytesLE(sample).map(_.U)
          ) // convert sample to Byte packets and enqueue them.
          dut.out.expectDequeue(
            sample.S // we expect the fully formed sample back
          )
        }
      }
    }
    s"SampleToBytes ($width-bit)" should "emit LSB first" in {
      test(new SamplesToBytes(p = p)) { dut =>
        dut.in.initSource().setSourceClock(dut.clock)
        dut.out.initSink().setSinkClock(dut.clock)

        for (sample <- sineSamples) {
          dut.in.enqueue(sample.S)
          dut.out.expectDequeueSeq(toBytesLE(sample).map(_.U))
        }
      }
    }
  }
}
