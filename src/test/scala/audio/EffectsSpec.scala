package audio

import chisel3._
import chisel3.util._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers

import AudioTestingUtils._
import chiseltest._
import top.AudioCore

class GainSpec extends AnyFlatSpec with ChiselScalatestTester {
  it should "pass" in {
    test(new (AudioCore)) { dut =>
      dut.clock.setTimeout(0)
    }
  }
}

class SaturateSpec extends AnyFlatSpec with ChiselScalatestTester {
  implicit val p: AudioParams = AudioParams.test
  it should "saturate max amplitude" in {
    test(new Saturate(threshold=Some(p.maxAmp))).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      dut.in.initSource().setSourceClock(dut.clock)
      dut.out.initSink().setSinkClock(dut.clock)
      dut.switches.gain.poke(p.maxGain.S)
      dut.in.enqueue((p.maxAmp + 20).S)
      dut.out.expectDequeue(p.maxAmp.S)
    }
  }
}
