package utils
import chisel3._
import chisel3.util._
import audio.AudioParams

object SampleHelper {

  /**
    * Samples should not overflow when added. Assumes that 
    *
    * @param gainedSample
    * @param threshold
    * @return
    */
  def saturate(gainedSample: SInt, threshold: Option[Int] = None)(implicit p: AudioParams): SInt = {
    val thresholdInt: Int = threshold.getOrElse(p.maxAmp)
    Mux(gainedSample >= thresholdInt.S, thresholdInt.S, gainedSample)
    val saturatedSample: SInt = Wire(SInt(gainedSample.getWidth.W))
    when(gainedSample.abs >= thresholdInt.S) {
      when(gainedSample(gainedSample.getWidth - 1)) {
        saturatedSample := (-thresholdInt).S
      }.otherwise {
        saturatedSample := thresholdInt.S
      }
    }.otherwise {
      saturatedSample := gainedSample
    }
    saturatedSample
  }
}
