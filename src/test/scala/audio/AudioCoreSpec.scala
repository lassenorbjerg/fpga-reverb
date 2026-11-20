package audio

import audio.UartUtils.uartFrameUInt
import chisel3._
import chisel3.util._
import chiseltest._
import chiseltest.experimental.expose
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import top.AudioCore

import AudioTestingUtils._
import scala.collection.mutable.ArrayBuffer

class AudioCoreDUT(p: AudioParams) extends AudioCore(p = p) {
  val expected = IO(
    new Bundle {
      val sampleRead = Input(SInt(p.sampleWidth.W))
      val sampleWrite = Input(SInt(p.sampleWidth.W))
    }
  )
  val exposed = new Bundle {
    val toBytesIn = new Bundle {
      val ready = expose(toBytes.in.ready)
      val valid = expose(toBytes.in.valid)
      val bits = expose(toBytes.in.bits)
    } // the processed sample
  }
}

class AudioCoreSpec
    extends AnyFlatSpec
    with ChiselScalatestTester
    with Matchers {
  implicit val p: AudioParams =
    AudioParams.test
  "AudioCore" should "send out received bytes but with added gain" in {
    test(new AudioCoreDUT(p = p)).withAnnotations(Seq(WriteVcdAnnotation)) {
      dut =>
        dut.io.rx.initSource().setSourceClock(dut.clock)
        dut.io.tx.initSink().setSinkClock(dut.clock)
        val samples = PcmSineSample(freqHz = 2, numSamples = 128)
        val gain = 0
        dut.io.sw.gain.poke(gain)

        var processedSamples = ArrayBuffer[BigInt]()
        var expectedSamples = ArrayBuffer[BigInt]()

        for (sample <- samples) {
          dut.expected.sampleRead.poke(sample.S)
          val bytes = toBytesLE(sample)
          dut.io.rx.enqueueSeq(bytes.map(_.U))
          val expectedSample =
            saturateMock(sample + gain, p.maxAmp)
          dut.expected.sampleWrite.poke(expectedSample.S)
          dut.io.tx.ready.poke(1.B)
          while (
            !(dut.exposed.toBytesIn.ready
              .peekBoolean() && dut.exposed.toBytesIn.valid.peekBoolean())
          ) {
            dut.clock.step()
          }
          processedSamples += dut.exposed.toBytesIn.bits.peekInt()
        }
        assert(processedSamples.length == samples.length)
        assert(processedSamples == samples)

    }
  }
}
