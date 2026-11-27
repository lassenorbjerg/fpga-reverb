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
  val clkCntr = RegInit(0.U(20.W))
  clkCntr := clkCntr + 1.U
  val exposed = new Bundle {
    val toBytesIn = new Bundle {
      val ready = expose(toBytes.in.ready)
      val valid = expose(toBytes.in.valid)
      val bits = expose(toBytes.in.bits)
    } // the processed sample
    val toSamplesOut = new Bundle {
      val toSamplesOutReady = expose(toSamples.out.ready)
      val toSamplesOutValid = expose(toSamples.out.valid)
      val toSamplesOutBits = expose(toSamples.out.bits)
    }  // the read sample
  }
}

class AudioCoreSpec
    extends AnyFlatSpec
    with ChiselScalatestTester
    with Matchers {
  implicit val p: AudioParams =
    AudioParams.test
  val timeoutMax = 100_000
  "AudioCore" should "send out received bytes but with added gain" in {
    test(new AudioCoreDUT(p = p)).withAnnotations(Seq(WriteVcdAnnotation)) {
      dut =>
        dut.io.rx.initSource().setSourceClock(dut.clock)
        dut.io.tx.initSink().setSinkClock(dut.clock)
        dut.io.tx.ready.poke(1.B)

        val samples = PcmSineSample(freqHz = 2, numSamples = 128)
        val gain = 0
        dut.io.sw.gain.poke(gain)
        val expected = samples.map(s => saturateMock(s + gain, p.maxAmp))

        val processed = ArrayBuffer[BigInt]()

        // monitor: record every handshake into toBytes
        val monitor = fork {
          var timeout = 0
          while (processed.length < samples.length && timeout < timeoutMax) {
            if (dut.exposed.toBytesIn.ready.peekBoolean() && dut.exposed.toBytesIn.valid.peekBoolean()) {
              processed += dut.exposed.toBytesIn.bits.peekInt()
            }
            dut.clock.step()
            timeout += 1
          }
        }

        // driver: push all bytes
        dut.io.rx.enqueueSeq(samples.flatMap(toBytesLE).map(_.U))

        monitor.join()

       assert( processed.length == samples.length, s"processed.length =/= samples.length. ${processed.length} =/= ${samples.length}")
        for (((got,exp),i) <- processed.zip(expected).zipWithIndex)
          assert(got == exp, s"@$i: got $got expected $exp (in=${samples(i)})")
    }
  }
}
