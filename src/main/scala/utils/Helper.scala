package utils
import chisel3._
import chisel3.util._

object SampleHelperSInt {

  /** Samples should not overflow. Currently just saturates. Generates
    *   - comparator if in >= max
    *   - a mux that chooses max if above threshold
    *
    * @param raw
    * @return
    */
  def saturate(gainedSample: SInt, threshold: Int = Env.maxAmp): SInt = {
    Mux(gainedSample >= threshold.S, threshold.S, gainedSample)
  }
}
