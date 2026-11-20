package audio

import chisel3._
import chisel3.util._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import top.AudioCore

import AudioTestingUtils._

class Dummy extends Module {}



class AudioTestingUtilsSpec
    extends AnyFlatSpec
    with ChiselScalatestTester
    with Matchers {
  implicit val p: AudioParams =
    AudioParams.test
  "PcmSineSample" should "generate following lookup table" in {
    test(new Dummy) { dut => 
      val twoHz = PcmSineSample(freqHz = 2, numSamples = 128)
      
      }
  }
}
