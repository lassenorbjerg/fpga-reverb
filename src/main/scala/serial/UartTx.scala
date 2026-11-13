// written by opus 5.5
package serial

import chisel3._
import chisel3.util._
import chisel.lib.uart.UartIO

/** UART transmitter, 8N1: 1 start bit, 8 data bits (LSB first), 1 stop bit.
  *
  * Drop-in replacement for chisel.lib.uart.Tx, which always sends 2 stop bits
  * (11 bit-times per byte). Echoing a host that sends 8N1 (10 bit-times per
  * byte) through that Tx makes the output ~9% slower than the input, so any
  * receive buffer eventually overflows.
  *
  * Two things keep this transmitter at line rate:
  *   - Back-to-back frames: a new byte is accepted on the same cycle the stop
  *     bit ends, so there is no idle gap between frames.
  *   - Fractional bit timing: a phase accumulator adds `baudRate` every clock
  *     and ticks when it passes `frequency`. At 100 MHz / 921600 the bit period
  *     alternates between 108 and 109 cycles, averaging exactly the requested
  *     baud. An integer divider (109 cycles) would be 0.45% slow. The jitter is
  *     at most one clock (~1% of a bit), far inside UART tolerance.
  */
class UartTx(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val txd = Output(UInt(1.W))
    val channel = Flipped(new UartIO())
  })

  require(baudRate > 0 && 2 * baudRate <= frequency, "Baud rate must be at most half the clock frequency")

  // Phase accumulator for the bit timer. acc stays below frequency, sum below frequency + baudRate.
  val acc = RegInit(0.U(log2Ceil(frequency + baudRate + 1).W))
  val sum = acc +& baudRate.U
  val tick = sum >= frequency.U // the current bit has lasted long enough

  val shiftReg = RegInit(((1 << 10) - 1).U(10.W)) // line idles high
  val bitsReg = RegInit(0.U(4.W)) // bits left in the frame, including the one on the line

  val busy = bitsReg =/= 0.U
  val stopBitEnding = bitsReg === 1.U && tick

  io.txd := shiftReg(0)
  io.channel.ready := !busy || stopBitEnding // accept the next byte without an idle gap

  when(busy) {
    acc := Mux(tick, sum - frequency.U, sum)
  }

  when(io.channel.fire) {
    shiftReg := Cat(1.U(1.W), io.channel.bits, 0.U(1.W)) // stop, data, start (start is sent first)
    bitsReg := 10.U
    when(!busy) {
      acc := 0.U // start a fresh bit period when leaving idle; back-to-back frames keep the phase
    }
  }.elsewhen(busy && tick) {
    shiftReg := Cat(1.U(1.W), shiftReg(9, 1))
    bitsReg := bitsReg - 1.U
  }
}
