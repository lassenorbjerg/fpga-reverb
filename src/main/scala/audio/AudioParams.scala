package audio

import chisel3._
import chisel3.util._
import utils.Env

/** Everything that decides widths lives here, so changing bit depth or buffer
  * size is a one-line change and every module follows.
  *
  * @param sampleWidth bits per PCM sample (8, 16 or 24). Signed two's complement,
  *                    sent little-endian over UART (LSB byte first).
  * @param delayDepth  samples in each delay line. Must be a power of two so the
  *                    circular-buffer pointer wraps for free.
  *                    16-bit x 32768 = 512 Kb, roughly 16 of the 50 BRAM36 blocks.
  */
case class AudioParams(
    val sampleWidth: Int = Env.sampleWidth,
    val delayDepth: Int = Env.delayDepth
) {
  require(sampleWidth > 0, "Sample width must be positive")
  require(delayDepth > 0, "Delay depth must be positive")
  require(sampleWidth <= 32, "Sample width must not exceed 32 bits")
  require(sampleWidth % 8 == 0, "Sample width must be a multiple of 8")
  require(isPow2(delayDepth), "Delay depth must be a power of 2")

  val bytesPerSample: Int = sampleWidth / 8
  val delayAddrWidth: Int = log2Ceil(delayDepth)

  /** A fresh sample type. Call it, don't share one instance between ports. */
  def sample: SInt = SInt(sampleWidth.W)
}


object AudioParams {
  val hardware = AudioParams(sampleWidth = Env.sampleWidth, delayDepth = Env.delayDepth)
  val test = AudioParams()
}
