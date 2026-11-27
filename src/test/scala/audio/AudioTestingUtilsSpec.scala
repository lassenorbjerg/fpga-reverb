package audio

import chisel3._
import chisel3.util._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import top.AudioCore

import AudioTestingUtils._


class AudioTestingUtilsSpec extends AnyFlatSpec with Matchers {
  private val twoHzRef = Seq(0, 6393, 12539, 18204, 23170, 27245, 30273, 32137, 32767,
    32137, 30273, 27245, 23170, 18204, 12539, 6393, 0, -6393, -12539, -18204,
    -23170, -27245, -30273, -32137, -32767, -32137, -30273, -27245, -23170,
    -18204, -12539, -6393, 0, 6393, 12539, 18204, 23170, 27245, 30273, 32137,
    32767, 32137, 30273, 27245, 23170, 18204, 12539, 6393, 0, -6393, -12539,
    -18204, -23170, -27245, -30273, -32137, -32767, -32137, -30273, -27245,
    -23170, -18204, -12539, -6393, 0, 6393, 12539, 18204, 23170, 27245, 30273,
    32137, 32767, 32137, 30273, 27245, 23170, 18204, 12539, 6393, 0, -6393,
    -12539, -18204, -23170, -27245, -30273, -32137, -32767, -32137, -30273,
    -27245, -23170, -18204, -12539, -6393, 0, 6393, 12539, 18204, 23170, 27245,
    30273, 32137, 32767, 32137, 30273, 27245, 23170, 18204, 12539, 6393, 0, -6393,
    -12539, -18204, -23170, -27245, -30273, -32137, -32767, -32137, -30273,
    -27245, -23170, -18204, -12539, -6393)  // generated in excel using below set audio params
  implicit val p: AudioParams =
    AudioParams.test.copy(sampleRate = 64, sampleWidth = 16)
  "PcmSineSample" should "generate following lookup table" in {
    val twoHz = PcmSineSample(freqHz = 2, numSamples = 128)
    assert(twoHzRef == twoHz)
  }
  "PcmSineSample" should "generate following lookup table without zeros" in {
    val twoHzRefNoZeros = twoHzRef.filter(_ != 0)
    val twoHz = PcmSineSample(freqHz = 2, numSamples = twoHzRefNoZeros.length, skipZeros = true)
    assert(twoHzRefNoZeros == twoHz)
  }
}
