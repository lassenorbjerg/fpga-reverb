package audio

import chisel3._
import chisel3.util._
import utils.Env.gainWidth
import utils.Env.sampleWidth
import utils._

/** Everything that decides widths lives here, so changing bit depth or buffer
  * size is a one-line change and every module follows.
  *
  * @param sampleWidth
  *   bits per PCM sample (8, 16 or 24). Signed two's complement, sent
  *   little-endian over UART (LSB byte first).
  * @param sampleRate
  * @param gainWidth
  * @param baudRate
  * @param clockFreq
  * @param msDelay
  * @param enAlwaysHigh:
  *   Makes AudioCore always send a high `en` signal. Useful for testing
  */
case class AudioParams(
    val sampleWidth: Int = Env.sampleWidth,
    val sampleRate: Int = Env.sampleRate,
    val gainWidth: Int = Env.gainWidth,
    val baudRate: Int = Env.BaudRate,
    val clockFreq: Int = Board.clockFreq,
    val msDelay: Int = Env.msDelay,
    val enAlwaysHigh: Boolean = false
) {
  require(sampleWidth > 0, "Sample width must be positive")
  require(sampleWidth <= 32, "Sample width must not exceed 32 bits")
  require(sampleWidth % 8 == 0, "Sample width must be a multiple of 8")
  require(gainWidth >= 0, "gainWidth cannot be negative")
  require(msDelay >= 0, "msDelay cannot be negative")

  val bytesPerSample: Int = sampleWidth / 8

  val maxSampleVal: Int = 2 << (sampleWidth - 1) - 1 // 2^(w-1) - 1
  val minSampleVal: Int = -2 << (sampleWidth - 1) // -2^(w-1)
  val maxAmp: Int = maxSampleVal * 3 / 4 // We do not want to break our ears o_O
  val maxGain: Int = ((1 << (gainWidth - 1)) - 1) // It is signed.

  /** A fresh sample type. Call it, don't share one instance between ports. */
  def sample: SInt = SInt(sampleWidth.W)
}

object AudioParams {
  val hardware = AudioParams() // use all defaults
  val test = AudioParams( // predefined parameters useful for most tests
    sampleWidth = 16,
    sampleRate = 64,
    gainWidth = 4,
    baudRate = 256,
    clockFreq = 512,
    msDelay = 0,
    enAlwaysHigh = true
  )
}
