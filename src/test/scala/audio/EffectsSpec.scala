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
  it should "pass" in {
    test(new (AudioCore)) { dut =>
      dut.clock.setTimeout(0)
    }
  }
}
