module Rx(
  input        clock,
  input        reset,
  input        io_rxd, // @[src/main/scala/chisel/lib/uart/Uart.scala 67:14]
  input        io_channel_ready, // @[src/main/scala/chisel/lib/uart/Uart.scala 67:14]
  output       io_channel_valid, // @[src/main/scala/chisel/lib/uart/Uart.scala 67:14]
  output [7:0] io_channel_bits // @[src/main/scala/chisel/lib/uart/Uart.scala 67:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
`endif // RANDOMIZE_REG_INIT
  reg  rxReg_REG; // @[src/main/scala/chisel/lib/uart/Uart.scala 76:30]
  reg  rxReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 76:22]
  reg  falling_REG; // @[src/main/scala/chisel/lib/uart/Uart.scala 77:35]
  wire  falling = ~rxReg & falling_REG; // @[src/main/scala/chisel/lib/uart/Uart.scala 77:24]
  reg [7:0] shiftReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 79:25]
  reg [19:0] cntReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 80:23]
  reg [3:0] bitsReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 81:24]
  reg  valReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 82:23]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[src/main/scala/chisel/lib/uart/Uart.scala 85:22]
  wire [7:0] _shiftReg_T_1 = {rxReg,shiftReg[7:1]}; // @[src/main/scala/chisel/lib/uart/Uart.scala 88:20]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[src/main/scala/chisel/lib/uart/Uart.scala 89:24]
  wire  _GEN_0 = bitsReg == 4'h1 | valReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 91:27 92:14 82:23]
  assign io_channel_valid = valReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 104:20]
  assign io_channel_bits = shiftReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 103:19]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 76:30]
      rxReg_REG <= 1'h0; // @[src/main/scala/chisel/lib/uart/Uart.scala 76:30]
    end else begin
      rxReg_REG <= io_rxd; // @[src/main/scala/chisel/lib/uart/Uart.scala 76:30]
    end
    if (reset) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 76:22]
      rxReg <= 1'h0; // @[src/main/scala/chisel/lib/uart/Uart.scala 76:22]
    end else begin
      rxReg <= rxReg_REG; // @[src/main/scala/chisel/lib/uart/Uart.scala 76:22]
    end
    falling_REG <= rxReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 77:35]
    if (reset) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 79:25]
      shiftReg <= 8'h0; // @[src/main/scala/chisel/lib/uart/Uart.scala 79:25]
    end else if (!(cntReg != 20'h0)) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 84:24]
      if (bitsReg != 4'h0) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 86:31]
        shiftReg <= _shiftReg_T_1; // @[src/main/scala/chisel/lib/uart/Uart.scala 88:14]
      end
    end
    if (reset) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 80:23]
      cntReg <= 20'h6c; // @[src/main/scala/chisel/lib/uart/Uart.scala 80:23]
    end else if (cntReg != 20'h0) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 84:24]
      cntReg <= _cntReg_T_1; // @[src/main/scala/chisel/lib/uart/Uart.scala 85:12]
    end else if (bitsReg != 4'h0) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 86:31]
      cntReg <= 20'h6c; // @[src/main/scala/chisel/lib/uart/Uart.scala 87:12]
    end else if (falling) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 94:23]
      cntReg <= 20'ha1; // @[src/main/scala/chisel/lib/uart/Uart.scala 95:12]
    end
    if (reset) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 81:24]
      bitsReg <= 4'h0; // @[src/main/scala/chisel/lib/uart/Uart.scala 81:24]
    end else if (!(cntReg != 20'h0)) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 84:24]
      if (bitsReg != 4'h0) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 86:31]
        bitsReg <= _bitsReg_T_1; // @[src/main/scala/chisel/lib/uart/Uart.scala 89:13]
      end else if (falling) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 94:23]
        bitsReg <= 4'h8; // @[src/main/scala/chisel/lib/uart/Uart.scala 96:13]
      end
    end
    if (reset) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 82:23]
      valReg <= 1'h0; // @[src/main/scala/chisel/lib/uart/Uart.scala 82:23]
    end else if (valReg & io_channel_ready) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 99:36]
      valReg <= 1'h0; // @[src/main/scala/chisel/lib/uart/Uart.scala 100:12]
    end else if (!(cntReg != 20'h0)) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 84:24]
      if (bitsReg != 4'h0) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 86:31]
        valReg <= _GEN_0;
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  rxReg_REG = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  rxReg = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  falling_REG = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  shiftReg = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  cntReg = _RAND_4[19:0];
  _RAND_5 = {1{`RANDOM}};
  bitsReg = _RAND_5[3:0];
  _RAND_6 = {1{`RANDOM}};
  valReg = _RAND_6[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Tx(
  input        clock,
  input        reset,
  output       io_txd, // @[src/main/scala/chisel/lib/uart/Uart.scala 23:14]
  output       io_channel_ready, // @[src/main/scala/chisel/lib/uart/Uart.scala 23:14]
  input        io_channel_valid, // @[src/main/scala/chisel/lib/uart/Uart.scala 23:14]
  input  [7:0] io_channel_bits // @[src/main/scala/chisel/lib/uart/Uart.scala 23:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [10:0] shiftReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 30:25]
  reg [19:0] cntReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 31:23]
  reg [3:0] bitsReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 32:24]
  wire  _io_channel_ready_T = cntReg == 20'h0; // @[src/main/scala/chisel/lib/uart/Uart.scala 34:31]
  wire [9:0] shift = shiftReg[10:1]; // @[src/main/scala/chisel/lib/uart/Uart.scala 41:28]
  wire [10:0] _shiftReg_T_1 = {1'h1,shift}; // @[src/main/scala/chisel/lib/uart/Uart.scala 42:22]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[src/main/scala/chisel/lib/uart/Uart.scala 43:26]
  wire [10:0] _shiftReg_T_3 = {2'h3,io_channel_bits,1'h0}; // @[src/main/scala/chisel/lib/uart/Uart.scala 46:24]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[src/main/scala/chisel/lib/uart/Uart.scala 54:22]
  assign io_txd = shiftReg[0]; // @[src/main/scala/chisel/lib/uart/Uart.scala 35:21]
  assign io_channel_ready = cntReg == 20'h0 & bitsReg == 4'h0; // @[src/main/scala/chisel/lib/uart/Uart.scala 34:40]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 30:25]
      shiftReg <= 11'h7ff; // @[src/main/scala/chisel/lib/uart/Uart.scala 30:25]
    end else if (_io_channel_ready_T) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 37:24]
      if (bitsReg != 4'h0) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 40:27]
        shiftReg <= _shiftReg_T_1; // @[src/main/scala/chisel/lib/uart/Uart.scala 42:16]
      end else if (io_channel_valid) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 45:30]
        shiftReg <= _shiftReg_T_3; // @[src/main/scala/chisel/lib/uart/Uart.scala 46:18]
      end else begin
        shiftReg <= 11'h7ff; // @[src/main/scala/chisel/lib/uart/Uart.scala 49:18]
      end
    end
    if (reset) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 31:23]
      cntReg <= 20'h0; // @[src/main/scala/chisel/lib/uart/Uart.scala 31:23]
    end else if (_io_channel_ready_T) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 37:24]
      cntReg <= 20'h6c; // @[src/main/scala/chisel/lib/uart/Uart.scala 39:12]
    end else begin
      cntReg <= _cntReg_T_1; // @[src/main/scala/chisel/lib/uart/Uart.scala 54:12]
    end
    if (reset) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 32:24]
      bitsReg <= 4'h0; // @[src/main/scala/chisel/lib/uart/Uart.scala 32:24]
    end else if (_io_channel_ready_T) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 37:24]
      if (bitsReg != 4'h0) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 40:27]
        bitsReg <= _bitsReg_T_1; // @[src/main/scala/chisel/lib/uart/Uart.scala 43:15]
      end else if (io_channel_valid) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 45:30]
        bitsReg <= 4'hb; // @[src/main/scala/chisel/lib/uart/Uart.scala 47:17]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  shiftReg = _RAND_0[10:0];
  _RAND_1 = {1{`RANDOM}};
  cntReg = _RAND_1[19:0];
  _RAND_2 = {1{`RANDOM}};
  bitsReg = _RAND_2[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BytesToSample(
  input         clock,
  input         reset,
  output        in_ready, // @[\\src\\main\\scala\\audio\\SampleCodec.scala 15:14]
  input         in_valid, // @[\\src\\main\\scala\\audio\\SampleCodec.scala 15:14]
  input  [7:0]  in_bits, // @[\\src\\main\\scala\\audio\\SampleCodec.scala 15:14]
  input         out_ready, // @[\\src\\main\\scala\\audio\\SampleCodec.scala 16:15]
  output        out_valid, // @[\\src\\main\\scala\\audio\\SampleCodec.scala 16:15]
  output [15:0] out_bits // @[\\src\\main\\scala\\audio\\SampleCodec.scala 16:15]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [15:0] shift; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 18:22]
  reg [1:0] byteCounter; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 19:28]
  wire  full = byteCounter == 2'h2; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 20:26]
  wire  _T = in_ready & in_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire [23:0] _shift_T = {in_bits,shift}; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 27:17]
  wire [1:0] _byteCounter_T_1 = byteCounter + 2'h1; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 28:32]
  wire  _T_1 = out_ready & out_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  assign in_ready = ~full; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 22:15]
  assign out_valid = byteCounter == 2'h2; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 20:26]
  assign out_bits = shift; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 24:21]
  always @(posedge clock) begin
    if (reset) begin // @[\\src\\main\\scala\\audio\\SampleCodec.scala 18:22]
      shift <= 16'h0; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 18:22]
    end else if (_T) begin // @[\\src\\main\\scala\\audio\\SampleCodec.scala 26:18]
      shift <= _shift_T[23:8]; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 27:11]
    end
    if (reset) begin // @[\\src\\main\\scala\\audio\\SampleCodec.scala 19:28]
      byteCounter <= 2'h0; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 19:28]
    end else if (_T) begin // @[\\src\\main\\scala\\audio\\SampleCodec.scala 26:18]
      byteCounter <= _byteCounter_T_1; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 28:17]
    end else if (_T_1) begin // @[\\src\\main\\scala\\audio\\SampleCodec.scala 29:25]
      byteCounter <= 2'h0; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 30:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  shift = _RAND_0[15:0];
  _RAND_1 = {1{`RANDOM}};
  byteCounter = _RAND_1[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SamplesToBytes(
  input         clock,
  input         reset,
  output        in_ready, // @[\\src\\main\\scala\\audio\\SampleCodec.scala 41:14]
  input         in_valid, // @[\\src\\main\\scala\\audio\\SampleCodec.scala 41:14]
  input  [15:0] in_bits, // @[\\src\\main\\scala\\audio\\SampleCodec.scala 41:14]
  input         out_ready, // @[\\src\\main\\scala\\audio\\SampleCodec.scala 42:15]
  output        out_valid, // @[\\src\\main\\scala\\audio\\SampleCodec.scala 42:15]
  output [7:0]  out_bits // @[\\src\\main\\scala\\audio\\SampleCodec.scala 42:15]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [15:0] shift; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 44:22]
  reg [1:0] counter; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 45:24]
  wire  empty = counter == 2'h0; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 46:23]
  wire  _T = in_ready & in_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire  _T_1 = out_ready & out_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire [1:0] _counter_T_1 = counter - 2'h1; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 57:24]
  assign in_ready = counter == 2'h0; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 46:23]
  assign out_valid = ~empty; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 49:16]
  assign out_bits = shift[7:0]; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 50:20]
  always @(posedge clock) begin
    if (reset) begin // @[\\src\\main\\scala\\audio\\SampleCodec.scala 44:22]
      shift <= 16'h0; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 44:22]
    end else if (_T) begin // @[\\src\\main\\scala\\audio\\SampleCodec.scala 52:17]
      shift <= in_bits; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 53:11]
    end else if (_T_1) begin // @[\\src\\main\\scala\\audio\\SampleCodec.scala 55:25]
      shift <= {{8'd0}, shift[15:8]}; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 56:11]
    end
    if (reset) begin // @[\\src\\main\\scala\\audio\\SampleCodec.scala 45:24]
      counter <= 2'h0; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 45:24]
    end else if (_T) begin // @[\\src\\main\\scala\\audio\\SampleCodec.scala 52:17]
      counter <= 2'h2; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 54:13]
    end else if (_T_1) begin // @[\\src\\main\\scala\\audio\\SampleCodec.scala 55:25]
      counter <= _counter_T_1; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 57:13]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  shift = _RAND_0[15:0];
  _RAND_1 = {1{`RANDOM}};
  counter = _RAND_1[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module AudioCore(
  input        clock,
  input        reset,
  output       io_rx_ready, // @[\\src\\main\\scala\\top\\AudioCore.scala 14:14]
  input        io_rx_valid, // @[\\src\\main\\scala\\top\\AudioCore.scala 14:14]
  input  [7:0] io_rx_bits, // @[\\src\\main\\scala\\top\\AudioCore.scala 14:14]
  input        io_tx_ready, // @[\\src\\main\\scala\\top\\AudioCore.scala 14:14]
  output       io_tx_valid, // @[\\src\\main\\scala\\top\\AudioCore.scala 14:14]
  output [7:0] io_tx_bits // @[\\src\\main\\scala\\top\\AudioCore.scala 14:14]
);
  wire  toSamples_clock; // @[\\src\\main\\scala\\top\\AudioCore.scala 20:25]
  wire  toSamples_reset; // @[\\src\\main\\scala\\top\\AudioCore.scala 20:25]
  wire  toSamples_in_ready; // @[\\src\\main\\scala\\top\\AudioCore.scala 20:25]
  wire  toSamples_in_valid; // @[\\src\\main\\scala\\top\\AudioCore.scala 20:25]
  wire [7:0] toSamples_in_bits; // @[\\src\\main\\scala\\top\\AudioCore.scala 20:25]
  wire  toSamples_out_ready; // @[\\src\\main\\scala\\top\\AudioCore.scala 20:25]
  wire  toSamples_out_valid; // @[\\src\\main\\scala\\top\\AudioCore.scala 20:25]
  wire [15:0] toSamples_out_bits; // @[\\src\\main\\scala\\top\\AudioCore.scala 20:25]
  wire  toBytes_clock; // @[\\src\\main\\scala\\top\\AudioCore.scala 21:23]
  wire  toBytes_reset; // @[\\src\\main\\scala\\top\\AudioCore.scala 21:23]
  wire  toBytes_in_ready; // @[\\src\\main\\scala\\top\\AudioCore.scala 21:23]
  wire  toBytes_in_valid; // @[\\src\\main\\scala\\top\\AudioCore.scala 21:23]
  wire [15:0] toBytes_in_bits; // @[\\src\\main\\scala\\top\\AudioCore.scala 21:23]
  wire  toBytes_out_ready; // @[\\src\\main\\scala\\top\\AudioCore.scala 21:23]
  wire  toBytes_out_valid; // @[\\src\\main\\scala\\top\\AudioCore.scala 21:23]
  wire [7:0] toBytes_out_bits; // @[\\src\\main\\scala\\top\\AudioCore.scala 21:23]
  BytesToSample toSamples ( // @[\\src\\main\\scala\\top\\AudioCore.scala 20:25]
    .clock(toSamples_clock),
    .reset(toSamples_reset),
    .in_ready(toSamples_in_ready),
    .in_valid(toSamples_in_valid),
    .in_bits(toSamples_in_bits),
    .out_ready(toSamples_out_ready),
    .out_valid(toSamples_out_valid),
    .out_bits(toSamples_out_bits)
  );
  SamplesToBytes toBytes ( // @[\\src\\main\\scala\\top\\AudioCore.scala 21:23]
    .clock(toBytes_clock),
    .reset(toBytes_reset),
    .in_ready(toBytes_in_ready),
    .in_valid(toBytes_in_valid),
    .in_bits(toBytes_in_bits),
    .out_ready(toBytes_out_ready),
    .out_valid(toBytes_out_valid),
    .out_bits(toBytes_out_bits)
  );
  assign io_rx_ready = toSamples_in_ready; // @[\\src\\main\\scala\\top\\AudioCore.scala 24:16]
  assign io_tx_valid = toBytes_out_valid; // @[\\src\\main\\scala\\top\\AudioCore.scala 26:15]
  assign io_tx_bits = toBytes_out_bits; // @[\\src\\main\\scala\\top\\AudioCore.scala 26:15]
  assign toSamples_clock = clock;
  assign toSamples_reset = reset;
  assign toSamples_in_valid = io_rx_valid; // @[\\src\\main\\scala\\top\\AudioCore.scala 24:16]
  assign toSamples_in_bits = io_rx_bits; // @[\\src\\main\\scala\\top\\AudioCore.scala 24:16]
  assign toSamples_out_ready = toBytes_in_ready; // @[\\src\\main\\scala\\top\\AudioCore.scala 25:14]
  assign toBytes_clock = clock;
  assign toBytes_reset = reset;
  assign toBytes_in_valid = toSamples_out_valid; // @[\\src\\main\\scala\\top\\AudioCore.scala 25:14]
  assign toBytes_in_bits = toSamples_out_bits; // @[\\src\\main\\scala\\top\\AudioCore.scala 25:14]
  assign toBytes_out_ready = io_tx_ready; // @[\\src\\main\\scala\\top\\AudioCore.scala 26:15]
endmodule
module Top(
  input         clock,
  input         reset,
  input         io_rxd, // @[\\src\\main\\scala\\top\\Top.scala 12:14]
  output        io_txd, // @[\\src\\main\\scala\\top\\Top.scala 12:14]
  input  [15:0] io_sw // @[\\src\\main\\scala\\top\\Top.scala 12:14]
);
  wire  rx_clock; // @[\\src\\main\\scala\\top\\Top.scala 18:18]
  wire  rx_reset; // @[\\src\\main\\scala\\top\\Top.scala 18:18]
  wire  rx_io_rxd; // @[\\src\\main\\scala\\top\\Top.scala 18:18]
  wire  rx_io_channel_ready; // @[\\src\\main\\scala\\top\\Top.scala 18:18]
  wire  rx_io_channel_valid; // @[\\src\\main\\scala\\top\\Top.scala 18:18]
  wire [7:0] rx_io_channel_bits; // @[\\src\\main\\scala\\top\\Top.scala 18:18]
  wire  tx_clock; // @[\\src\\main\\scala\\top\\Top.scala 26:18]
  wire  tx_reset; // @[\\src\\main\\scala\\top\\Top.scala 26:18]
  wire  tx_io_txd; // @[\\src\\main\\scala\\top\\Top.scala 26:18]
  wire  tx_io_channel_ready; // @[\\src\\main\\scala\\top\\Top.scala 26:18]
  wire  tx_io_channel_valid; // @[\\src\\main\\scala\\top\\Top.scala 26:18]
  wire [7:0] tx_io_channel_bits; // @[\\src\\main\\scala\\top\\Top.scala 26:18]
  wire  core_clock; // @[\\src\\main\\scala\\top\\Top.scala 34:20]
  wire  core_reset; // @[\\src\\main\\scala\\top\\Top.scala 34:20]
  wire  core_io_rx_ready; // @[\\src\\main\\scala\\top\\Top.scala 34:20]
  wire  core_io_rx_valid; // @[\\src\\main\\scala\\top\\Top.scala 34:20]
  wire [7:0] core_io_rx_bits; // @[\\src\\main\\scala\\top\\Top.scala 34:20]
  wire  core_io_tx_ready; // @[\\src\\main\\scala\\top\\Top.scala 34:20]
  wire  core_io_tx_valid; // @[\\src\\main\\scala\\top\\Top.scala 34:20]
  wire [7:0] core_io_tx_bits; // @[\\src\\main\\scala\\top\\Top.scala 34:20]
  Rx rx ( // @[\\src\\main\\scala\\top\\Top.scala 18:18]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_rxd(rx_io_rxd),
    .io_channel_ready(rx_io_channel_ready),
    .io_channel_valid(rx_io_channel_valid),
    .io_channel_bits(rx_io_channel_bits)
  );
  Tx tx ( // @[\\src\\main\\scala\\top\\Top.scala 26:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  AudioCore core ( // @[\\src\\main\\scala\\top\\Top.scala 34:20]
    .clock(core_clock),
    .reset(core_reset),
    .io_rx_ready(core_io_rx_ready),
    .io_rx_valid(core_io_rx_valid),
    .io_rx_bits(core_io_rx_bits),
    .io_tx_ready(core_io_tx_ready),
    .io_tx_valid(core_io_tx_valid),
    .io_tx_bits(core_io_tx_bits)
  );
  assign io_txd = tx_io_txd; // @[\\src\\main\\scala\\top\\Top.scala 32:10]
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_rxd = io_rxd; // @[\\src\\main\\scala\\top\\Top.scala 24:13]
  assign rx_io_channel_ready = core_io_rx_ready; // @[\\src\\main\\scala\\top\\Top.scala 37:14]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = core_io_tx_valid; // @[\\src\\main\\scala\\top\\Top.scala 38:17]
  assign tx_io_channel_bits = core_io_tx_bits; // @[\\src\\main\\scala\\top\\Top.scala 38:17]
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_rx_valid = rx_io_channel_valid; // @[\\src\\main\\scala\\top\\Top.scala 37:14]
  assign core_io_rx_bits = rx_io_channel_bits; // @[\\src\\main\\scala\\top\\Top.scala 37:14]
  assign core_io_tx_ready = tx_io_channel_ready; // @[\\src\\main\\scala\\top\\Top.scala 38:17]
endmodule
