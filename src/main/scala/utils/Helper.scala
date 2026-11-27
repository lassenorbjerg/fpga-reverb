package utils
import audio.AudioParams
import chisel3._
import chisel3.util._

object SampleHelper {

  /** Samples should not overflow when added. Assumes that
    *
    * @param gainedSample
    * @param threshold
    * @return
    */
  def saturate(gainedSample: SInt, threshold: Option[Int] = None)(implicit
      p: AudioParams
  ): SInt = {
    val thresholdInt: Int = threshold.getOrElse(p.maxAmp)
    val saturatedSample: SInt = Wire(SInt(gainedSample.getWidth.W))
    when(gainedSample >= thresholdInt.S) {
      saturatedSample := thresholdInt.S
    }.elsewhen(gainedSample <= (-thresholdInt).S) {
      saturatedSample := (-thresholdInt).S
    }.otherwise {
      saturatedSample := gainedSample
    }
    saturatedSample
  }

  def msToSampleDelay(ms: Int)(implicit p: AudioParams): Int = {
    require(ms >= 0, "requires ms >= 0")
    // sampleRate: samples/s
    // ms: s/1000
    //
    // sampleRate * ms * 1000 = sample delay
    // samples/s * s/1000 * 1000 = samples
    if (ms == 0) {
      return 1
    }
    return p.sampleRate * ms * 1000
  }
}
