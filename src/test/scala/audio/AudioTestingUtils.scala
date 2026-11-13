package audio

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

  /** Splits sample into byte sized chunks. The bytes are unsigned. And in little-endian (LE) */
  def toBytesLE(sample: Int)(implicit p: AudioParams): Seq[Int] =
    (0 until p.bytesPerSample).map(i =>
      (sample >> (8 * i) & 0xff)  // 0xff is 1 byte of 1s
      // example:
      // i=0: (0x1234 >> 0) & 0xff = 0x1234 & 0xff = 0x34   (LSB)
      // i=1: (0x1234 >> 8) & 0xff = 0x0012 & 0xff = 0x12   (MSB)
    )

}
