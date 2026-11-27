package audio

import chisel3._
import chisel3.util._
import chiseltest._
import firrtl.AnnotationSeq
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import top.AudioCore

import AudioTestingUtils._

trait AudioEffectSpec extends AnyFlatSpec with ChiselScalatestTester {
  implicit val p: AudioParams = AudioParams.test

  // Claude has written the setup and testEffect
  def setup[T <: AudioEffect](dut: T): Unit = {
    dut.in.initSource().setSourceClock(dut.clock)
    dut.out.initSink().setSinkClock(dut.clock)
    dut.switches.en.poke(1.U)
  }

  def testEffect[T <: AudioEffect](
      gen: => T,
      wave: Boolean = false
  )(body: T => Unit): Unit = {
    val annotations = if (wave) Seq(WriteVcdAnnotation) else Seq()

    test(gen).withAnnotations(annotations) { dut =>
      setup(dut)
      body(dut)
    }
  }

  def enqDeqExpect[T <: AudioEffect](
      samples: Seq[SInt],
      expected: Seq[SInt],
      dut: T
  ): Unit = {
    assert(
      samples.length == expected.length,
      "Samples and expected are not of equal length"
    )

    for ((sample, expectedSample) <- samples.zip(expected)) {
      dut.in.enqueue(sample)
      dut.out.expectDequeue(expectedSample)
    }
  }

  // example:
  // it should "pass" in {
  // testEffect(new AudioEffect, wave=true) { dut =>
  //      dut.in.enqueue(10.S)
  //      dut.in.expectDequeue(10.S)
  //   }
  // }
}

class SaturateSpec extends AudioEffectSpec {
  it should "saturate max amplitude" in {
    testEffect(new Saturate(threshold = Some(p.maxAmp))) { dut =>
      dut.in.initSource().setSourceClock(dut.clock)
      dut.out.initSink().setSinkClock(dut.clock)
      dut.switches.gain.poke(50.S)
      dut.in.enqueue((p.maxAmp - 20).S) // implicit gain test as well
      dut.out.expectDequeue(p.maxAmp.S)
    }
  }
  it should "Subtract gain from negative number" in {
    testEffect(new Saturate(threshold = Some(p.maxAmp))) { dut =>
      val gain = 20
      val sample = -100
      val expected = -120
      dut.in.initSource().setSourceClock(dut.clock)
      dut.out.initSink().setSinkClock(dut.clock)
      dut.switches.gain.poke(gain.S)
      dut.in.enqueue(sample.S)
      dut.out.expectDequeue(expected.S)
    }
  }
}

class DelaySpec extends AudioEffectSpec {
  it should "delay samples generic" in {
    val delaySamples = 2
    testEffect(
      new Delay(delaySamples = delaySamples),
      wave = true
    ) { dut =>
      val samples =
        Seq(9, 8, 7, 6, 5, 4, 3, 2, 1) // we want to send these samples
      val samplesSInt = samples.map(
        _.S
      ) // we want to empty the delay line so we add extra empty samples
      val expected =
        samples // we expect the delay line to be emptied in the start
      val expectedSInt = expected.map(_.S)

      enqDeqExpect(samplesSInt, expectedSInt, dut)
    }
  }
  it should "delay samples explicit simple" in {
    val delaySamples = 2  // do not change
    testEffect(
      new Delay(delaySamples = delaySamples),
      wave=true
    ) { dut =>
      dut.in.enqueue(9.S)
      dut.in.enqueue(8.S)
      dut.in.enqueue(7.S)
      dut.out.expectDequeue(9.S)
      dut.in.enqueue(6.S)
      dut.out.expectDequeue(8.S)
      dut.in.enqueue(5.S)
      dut.out.expectDequeueSeq(Seq(7,6,5).map(_.S))
    }
  }
}
