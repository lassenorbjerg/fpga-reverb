// inspired from https://github.com/bathtuballigator/chisel-synth/blob/eee9beb/src/main/scala/VerilogGen.scala
package utils
// Created with Sonnet 5.5
import chisel3._
import circt.stage.ChiselStage

import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths

/**
  * Helper for generating Verilog with custom name and folder location
  */
object VerilogGen {
  def apply(
      gen: => RawModule,
      fileName: String,
      outDir: String = "generated"
  ): Path = {
    val output = Paths.get(outDir, fileName)
    Files.createDirectories(output.getParent)
    val verilog = ChiselStage.emitSystemVerilog(gen)
    Files.write(output, verilog.getBytes(StandardCharsets.UTF_8))
    println(s"Verilog written to ${output.toAbsolutePath}")
    output
  }
}
