package audio
import chisel3._
import chisel3.util._

object AudioTestingUtils {

  /** @param freqHz
    * @param numSamples
    * @param p
    * @return
    */
  def PcmSineSample(freqHz: Int = 2, numSamples: Int = 10)(implicit
      p: AudioParams
  ): Seq[Int] = {
    val amplitude = (1 << (p.sampleWidth - 1)) - 1 // 127 for 8-bit
    for (i <- 0 until numSamples)
      yield (amplitude * Math.sin( // split sine wave up into samples
        2.0 * Math.PI * freqHz * i / p.sampleRate
      )).round.toInt
  }

  /** Splits sample into byte sized chunks. The bytes are unsigned. And in
    * little-endian (LE)
    */
  def toBytesLE(sample: Int)(implicit p: AudioParams): Seq[Int] =
    (0 until p.bytesPerSample).map(i =>
      (sample >> (8 * i) & 0xff) // 0xff is 1 byte of 1s
      // example:
      // i=0: (0x1234 >> 0) & 0xff = 0x1234 & 0xff = 0x34   (LSB)
      // i=1: (0x1234 >> 8) & 0xff = 0x0012 & 0xff = 0x12   (MSB)
    )

  /** Compute the expected gained sample in software
    *
    * @param sample
    * @param gain
    * @param p
    * @return
    */
  def gainMock(sample: Int, gain: Int)(implicit p: AudioParams): Int = {
    sample * (gain / p.maxGain)
  }

  /** Compute the expected sample after saturation in software.
    *
    * Note: saturation compares absolute value of sample. So the negative
    * threshold is equal to the positive. Sign is still kept after saturation.
    *
    * @param sample
    * @param gain
    * @param p
    * @return
    */
  def saturateMock(sample: Int, threshold: Int)(implicit p: AudioParams): Int =
    if (sample >= threshold) threshold
    else if (sample <= -threshold) -threshold
    else sample
}

object UartUtils {

  /** Return byte as a 8n1 (1 start and stop bit) uart frame as Int bits (0 or
    * 1).
    *
    * In tests: For reading:
    *   - poke rx port. The clock should be stepped for clkFreq/baudRate
    * steps.
    *
    * @param byte
    * @return
    */
  def uartFrameBits(byte: Int): Seq[Int] =
    Seq(0) ++ (0 until 8).map(i => (byte >> i) & 1) ++ Seq(1)

  /** Return byte as a 8n1 (1 start and stop bit) uart frame as UInt.
    *
    * Can be used to poke or as a reference for asserting.
    *
    * @param byte
    * @return
    */
  def uartFrameUInt(byte: Int): UInt =
    ("b" + uartFrameBits(byte).mkString).U

  def cyclesPerBit()(implicit p: AudioParams): Int = {
    (p.clockFreq.toDouble / p.baudRate).toInt // should it be ceiled?
  }
}

// object DecoupledUtils {
//   /**
//     * E.g. rx
//     *
//     * @param dut
//     * @param source: Input E.g. rx
//     */
//   def setupSource(dut: Module, source: DecoupledIO[Any]): Unit = {
//     source.initSource().setSourceClock(dut.clock)
//   }
//   /**
//     * E.g. tx
//     *
//     * @param dut
//     * @param sink: Output E.g. rx
//     */
//   def setupSink(dut: Module, sink: DecoupledIO[Any]): Unit = {
//     sink.initSink().setSinkClock(dut.clock)
//   }
// }
