package utils
import chisel3._
import chisel3.util._
import audio.AudioParams

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
}
