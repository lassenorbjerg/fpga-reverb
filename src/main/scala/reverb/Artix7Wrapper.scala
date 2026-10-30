package reverb

import chisel3._
import chisel3.util._

class FIFO_DUAL_CLOCK_MACRO(
    DATA_WIDTH: Int, // Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
    FIFO_SIZE: String = "36Kb", // Target BRAM: "18Kb" or "36Kb"
    FIRST_WORD_FALL_THROUGH: String // Sets the FIFO FWFT to "TRUE" or "FALSE"
) extends BlackBox
    with HasBlackBoxInline {
  // RDCOUNT/WRCOUNT width from the depth table in the Xilinx template
  private val depth = (FIFO_SIZE, DATA_WIDTH) match {
    case ("36Kb", w) if w >= 37 => 512
    case ("36Kb", w) if w >= 19 => 1024
    case ("36Kb", w) if w >= 10 => 2048
    case ("36Kb", w) if w >= 5  => 4096
    case ("36Kb", _)            => 8192
    case (_, w) if w >= 19      => 512
    case (_, w) if w >= 10      => 1024
    case (_, w) if w >= 5       => 2048
    case _                      => 4096
  }
  private val countWidth = log2Ceil(depth)

  val io = IO(new Bundle {
    val ALMOSTEMPTY = Output(Bool())               // 1-bit output almost empty               
    val ALMOSTFULL  = Output(Bool())               // 1-bit output almost full               
    val DO          = Output(UInt(DATA_WIDTH.W))   // Output data, width defined by DATA_WIDTH parameter                           
    val EMPTY       = Output(Bool())               // 1-bit output empty               
    val FULL        = Output(Bool())               // 1-bit output full               
    val RDCOUNT     = Output(UInt(countWidth.W))   // Output read count, width determined by FIFO depth                           
    val RDERR       = Output(Bool())               // 1-bit output read error               
    val WRCOUNT     = Output(UInt(countWidth.W))   // Output write count, width determined by FIFO depth                           
    val WRERR       = Output(Bool())               // 1-bit output write error               
    val DI          = Input(UInt(DATA_WIDTH.W))    // Input data, width defined by DATA_WIDTH parameter                         
    val RDCLK       = Input(Clock())               // 1-bit input read clock               
    val RDEN        = Input(Bool())                // 1-bit input read enable             
    val RST         = Input(Bool())                // 1-bit input reset             
    val WRCLK       = Input(Clock())               // 1-bit input write clock               
    val WREN        = Input(Bool())                // 1-bit input write enable             

  })
  require(
    Seq("18Kb", "36Kb").contains(FIFO_SIZE),
    s"FIFO_SIZE must be \"18Kb\" or \"36Kb\", got \"$FIFO_SIZE\""
  )
  require(
    Seq("TRUE", "FALSE").contains(FIRST_WORD_FALL_THROUGH),
    s"FIRST_WORD_FALL_THROUGH must be \"TRUE\" or \"FALSE\", got \"$FIRST_WORD_FALL_THROUGH\""
  )

  setInline(
    "FIFO_DUAL_CLOCK_MACRO.v",
    s"""
|
|// FIFO_DUALCLOCK_MACRO : In order to incorporate this function into the design,
|//     Verilog          : the following instance declaration needs to be placed
|//    instance          : in the body of the design code.  The instance name
|//   declaration        : (FIFO_DUALCLOCK_MACRO_inst) and/or the port declarations within the
|//      code            : parenthesis may be changed to properly reference and
|//                      : connect this function to the design.  All inputs
|//                      : and outputs must be connected.
|
|//  <-----Cut code below this line---->
|
|   // FIFO_DUALCLOCK_MACRO: Dual Clock First-In, First-Out (FIFO) RAM Buffer
|   //                       Artix-7
|   // Xilinx HDL Language Template, version 2025.1
|
|   /////////////////////////////////////////////////////////////////
|   // DATA_WIDTH | FIFO_SIZE | FIFO Depth | RDCOUNT/WRCOUNT Width //
|   // ===========|===========|============|=======================//
|   //   37-72    |  "36Kb"   |     512    |         9-bit         //
|   //   19-36    |  "36Kb"   |    1024    |        10-bit         //
|   //   19-36    |  "18Kb"   |     512    |         9-bit         //
|   //   10-18    |  "36Kb"   |    2048    |        11-bit         //
|   //   10-18    |  "18Kb"   |    1024    |        10-bit         //
|   //    5-9     |  "36Kb"   |    4096    |        12-bit         //
|   //    5-9     |  "18Kb"   |    2048    |        11-bit         //
|   //    1-4     |  "36Kb"   |    8192    |        13-bit         //
|   //    1-4     |  "18Kb"   |    4096    |        12-bit         //
|   /////////////////////////////////////////////////////////////////
|
|   FIFO_DUALCLOCK_MACRO  #(
|      .ALMOST_EMPTY_OFFSET(9'h080), // Sets the almost empty threshold
|      .ALMOST_FULL_OFFSET(9'h080),  // Sets almost full threshold
|      .DATA_WIDTH(${DATA_WIDTH}),   // Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
|      .DEVICE("7SERIES"),  // Target device: "7SERIES" 
|      .FIFO_SIZE ("${FIFO_SIZE}"), // Target BRAM: "18Kb" or "36Kb" 
|      .FIRST_WORD_FALL_THROUGH ("${FIRST_WORD_FALL_THROUGH}") // Sets the FIFO FWFT to "TRUE" or "FALSE" 
|   ) FIFO_DUALCLOCK_MACRO_inst (
|      .ALMOSTEMPTY(ALMOSTEMPTY), // 1-bit output almost empty
|      .ALMOSTFULL(ALMOSTFULL),   // 1-bit output almost full
|      .DO(DO),                   // Output data, width defined by DATA_WIDTH parameter
|      .EMPTY(EMPTY),             // 1-bit output empty
|      .FULL(FULL),               // 1-bit output full
|      .RDCOUNT(RDCOUNT),         // Output read count, width determined by FIFO depth
|      .RDERR(RDERR),             // 1-bit output read error
|      .WRCOUNT(WRCOUNT),         // Output write count, width determined by FIFO depth
|      .WRERR(WRERR),             // 1-bit output write error
|      .DI(DI),                   // Input data, width defined by DATA_WIDTH parameter
|      .RDCLK(RDCLK),             // 1-bit input read clock
|      .RDEN(RDEN),               // 1-bit input read enable
|      .RST(RST),                 // 1-bit input reset
|      .WRCLK(WRCLK),             // 1-bit input write clock
|      .WREN(WREN)                // 1-bit input write enable
|   );
|
|   // End of FIFO_DUALCLOCK_MACRO_inst instantiation
|				
|				
    """.stripMargin
  )
}

class Artix7Wrapper extends Module {}
