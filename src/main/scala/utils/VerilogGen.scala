// inspired from https://github.com/bathtuballigator/chisel-synth/blob/eee9beb/src/main/scala/VerilogGen.scala
// Created with Opus 5.5
package utils
import chisel3._
import chisel3.stage.ChiselStage

import java.nio.file.Path
import java.nio.file.Paths

/** Helper for generating Verilog with custom name and folder location
  */
object VerilogGen {
  def apply(
      gen: => RawModule,
      fileName: String,
      outDir: String = "generated"
  ): Path = {
    val baseName =
      fileName.stripSuffix(".v").stripSuffix(".sv") // Chisel adds ".v" itself
    (new ChiselStage)
      .emitVerilog(gen, Array("--target-dir", outDir, "-o", baseName))
    val output = Paths.get(outDir, s"$baseName.v")
    println(s"Verilog written to ${output.toAbsolutePath}")
    output
  }
}
