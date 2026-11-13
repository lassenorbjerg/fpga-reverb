package utils
import chisel3._
import chisel3.util._

object SampleHelper {

  /**
    * Samples should not overflow when added. Assumes that 
    *
    * @param gainedSample
    * @param threshold
    * @return
    */
  def saturate(gainedSample: SInt, threshold: Int = Env.maxAmp): SInt = {
    Mux(gainedSample >= threshold.S, threshold.S, gainedSample)
    val saturatedSample: SInt = Wire(SInt(gainedSample.getWidth.W))
    when(gainedSample.abs >= threshold.S) {
      when(gainedSample(gainedSample.getWidth - 1)) {
        saturatedSample := (-threshold).S
      }.otherwise {
        saturatedSample := threshold.S
      }
    }.otherwise {
      saturatedSample := gainedSample
    }
    saturatedSample
  }
}
