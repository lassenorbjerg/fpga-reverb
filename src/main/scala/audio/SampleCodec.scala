package audio

import chisel3._
import chisel3.util._
import utils.Env


/** UART bytes gets converted to samples through a shift reg. Because samples can contain multiple bytes.
  * Bytes arrive little-endian (smallest byte first).
  * 
  * When setting out.ready and out.valid is set. out.valid will be deasserted next clock cycle.
  * Note: Does not handle misalignment. Missing a byte will cause incorrect sample reconstruction.
 */
class BytesToSample(p: AudioParams) extends Module {
  val in = IO(Flipped(Decoupled(UInt(8.W))))  // The received byte
  val out = IO(Decoupled(p.sample))           // The produced sample

  val shift = RegInit(0.U(p.sampleWidth.W))  // we do not want to care about sign when constructing the sample
  val byteCounter = RegInit(0.U(log2Ceil(p.bytesPerSample + 1).W))  // How many bytes collected for the sample. +1 to sufficiently reach bytesPerSample
  val full = byteCounter === p.bytesPerSample.U

  in.ready := !full  // we are ready to receive bytes when we have not constructed the sample yet
  out.valid := full  // the sample has been fully constructed. So out is valid
  out.bits := shift.asSInt  // set sample as it is being constructed

  when (in.fire) {
    shift := Cat(in.bits, shift) >> 8  // push byte in and push old shift byte out
    byteCounter := byteCounter + 1.U  // we have collected a byte
  } .elsewhen(out.fire) {  // sample is being read
    byteCounter := 0.U
  }
}


/** Samples gets converted to Byte stream with handshake.
  * Bytes get sent out little-endian (smallest byte first).
  * 
  * 
  */
class SamplesToBytes(p: AudioParams) extends Module {
  val in = IO(Flipped(Decoupled(p.sample)))  // The consumed sample
  val out = IO(Decoupled(UInt(8.W)))         // The produced byte

  val shift = RegInit(0.U(p.sampleWidth.W))  // pump out sample one byte shifted at a time
  val counter = RegInit(0.U(log2Ceil(p.bytesPerSample + 1).W))
  val empty = counter === 0.U

  in.ready := empty  // we can receive another sample since we have sent all bytes out
  out.valid := !empty  // we still have bytes left to send
  out.bits := shift(7,0)  // inclusive 7th bit downto 0th = the smallest byte

  when(in.fire) {
    shift := in.bits.asUInt
    counter := p.bytesPerSample.U
  } .elsewhen(out.fire) {
    shift := shift >> 8  // out has received lowest byte. We shift the next byte in.
    counter := counter - 1.U  // one less byte to send
  }

}
