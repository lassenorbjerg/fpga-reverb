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
module UartTx(
  input        clock,
  input        reset,
  output       io_txd, // @[\\src\\main\\scala\\serial\\UartTx.scala 25:14]
  output       io_channel_ready, // @[\\src\\main\\scala\\serial\\UartTx.scala 25:14]
  input        io_channel_valid, // @[\\src\\main\\scala\\serial\\UartTx.scala 25:14]
  input  [7:0] io_channel_bits // @[\\src\\main\\scala\\serial\\UartTx.scala 25:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [26:0] acc; // @[\\src\\main\\scala\\serial\\UartTx.scala 33:20]
  wire [27:0] sum = acc + 27'he1000; // @[\\src\\main\\scala\\serial\\UartTx.scala 34:17]
  wire  tick = sum >= 28'h5f5e100; // @[\\src\\main\\scala\\serial\\UartTx.scala 35:18]
  reg [9:0] shiftReg; // @[\\src\\main\\scala\\serial\\UartTx.scala 37:25]
  reg [3:0] bitsReg; // @[\\src\\main\\scala\\serial\\UartTx.scala 38:24]
  wire  busy = bitsReg != 4'h0; // @[\\src\\main\\scala\\serial\\UartTx.scala 40:22]
  wire  stopBitEnding = bitsReg == 4'h1 & tick; // @[\\src\\main\\scala\\serial\\UartTx.scala 41:39]
  wire  _io_channel_ready_T = ~busy; // @[\\src\\main\\scala\\serial\\UartTx.scala 44:23]
  wire [27:0] _acc_T_1 = sum - 28'h5f5e100; // @[\\src\\main\\scala\\serial\\UartTx.scala 47:26]
  wire [27:0] _acc_T_2 = tick ? _acc_T_1 : sum; // @[\\src\\main\\scala\\serial\\UartTx.scala 47:15]
  wire [27:0] _GEN_0 = busy ? _acc_T_2 : {{1'd0}, acc}; // @[\\src\\main\\scala\\serial\\UartTx.scala 46:14 33:20 47:9]
  wire  _T = io_channel_ready & io_channel_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire [9:0] _shiftReg_T = {1'h1,io_channel_bits,1'h0}; // @[\\src\\main\\scala\\serial\\UartTx.scala 51:20]
  wire [27:0] _GEN_1 = _io_channel_ready_T ? 28'h0 : _GEN_0; // @[\\src\\main\\scala\\serial\\UartTx.scala 53:17 54:11]
  wire [9:0] _shiftReg_T_2 = {1'h1,shiftReg[9:1]}; // @[\\src\\main\\scala\\serial\\UartTx.scala 57:20]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[\\src\\main\\scala\\serial\\UartTx.scala 58:24]
  wire [27:0] _GEN_6 = _T ? _GEN_1 : _GEN_0; // @[\\src\\main\\scala\\serial\\UartTx.scala 50:25]
  wire [27:0] _GEN_7 = reset ? 28'h0 : _GEN_6; // @[\\src\\main\\scala\\serial\\UartTx.scala 33:{20,20}]
  assign io_txd = shiftReg[0]; // @[\\src\\main\\scala\\serial\\UartTx.scala 43:21]
  assign io_channel_ready = ~busy | stopBitEnding; // @[\\src\\main\\scala\\serial\\UartTx.scala 44:29]
  always @(posedge clock) begin
    acc <= _GEN_7[26:0]; // @[\\src\\main\\scala\\serial\\UartTx.scala 33:{20,20}]
    if (reset) begin // @[\\src\\main\\scala\\serial\\UartTx.scala 37:25]
      shiftReg <= 10'h3ff; // @[\\src\\main\\scala\\serial\\UartTx.scala 37:25]
    end else if (_T) begin // @[\\src\\main\\scala\\serial\\UartTx.scala 50:25]
      shiftReg <= _shiftReg_T; // @[\\src\\main\\scala\\serial\\UartTx.scala 51:14]
    end else if (busy & tick) begin // @[\\src\\main\\scala\\serial\\UartTx.scala 56:28]
      shiftReg <= _shiftReg_T_2; // @[\\src\\main\\scala\\serial\\UartTx.scala 57:14]
    end
    if (reset) begin // @[\\src\\main\\scala\\serial\\UartTx.scala 38:24]
      bitsReg <= 4'h0; // @[\\src\\main\\scala\\serial\\UartTx.scala 38:24]
    end else if (_T) begin // @[\\src\\main\\scala\\serial\\UartTx.scala 50:25]
      bitsReg <= 4'ha; // @[\\src\\main\\scala\\serial\\UartTx.scala 52:13]
    end else if (busy & tick) begin // @[\\src\\main\\scala\\serial\\UartTx.scala 56:28]
      bitsReg <= _bitsReg_T_1; // @[\\src\\main\\scala\\serial\\UartTx.scala 58:13]
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
  acc = _RAND_0[26:0];
  _RAND_1 = {1{`RANDOM}};
  shiftReg = _RAND_1[9:0];
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
module Queue(
  input        clock,
  input        reset,
  output       io_enq_ready, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  input        io_enq_valid, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  input  [7:0] io_enq_bits, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  input        io_deq_ready, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  output       io_deq_valid, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  output [7:0] io_deq_bits // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] ram [0:15]; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire  ram_io_deq_bits_MPORT_en; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire [3:0] ram_io_deq_bits_MPORT_addr; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire [7:0] ram_io_deq_bits_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire [7:0] ram_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire [3:0] ram_MPORT_addr; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire  ram_MPORT_mask; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire  ram_MPORT_en; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  reg [3:0] enq_ptr_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg [3:0] deq_ptr_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg  maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 282:27]
  wire  ptr_match = enq_ptr_value == deq_ptr_value; // @[src/main/scala/chisel3/util/Decoupled.scala 283:33]
  wire  empty = ptr_match & ~maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 284:25]
  wire  full = ptr_match & maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 285:24]
  wire  do_enq = io_enq_ready & io_enq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire  do_deq = io_deq_ready & io_deq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire [3:0] _value_T_1 = enq_ptr_value + 4'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire [3:0] _value_T_3 = deq_ptr_value + 4'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  assign ram_io_deq_bits_MPORT_en = 1'h1;
  assign ram_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_io_deq_bits_MPORT_data = ram[ram_io_deq_bits_MPORT_addr]; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  assign ram_MPORT_data = io_enq_bits;
  assign ram_MPORT_addr = enq_ptr_value;
  assign ram_MPORT_mask = 1'h1;
  assign ram_MPORT_en = io_enq_ready & io_enq_valid;
  assign io_enq_ready = ~full; // @[src/main/scala/chisel3/util/Decoupled.scala 309:19]
  assign io_deq_valid = ~empty; // @[src/main/scala/chisel3/util/Decoupled.scala 308:19]
  assign io_deq_bits = ram_io_deq_bits_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 316:17]
  always @(posedge clock) begin
    if (ram_MPORT_en & ram_MPORT_mask) begin
      ram[ram_MPORT_addr] <= ram_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      enq_ptr_value <= 4'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (do_enq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 292:16]
      enq_ptr_value <= _value_T_1; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      deq_ptr_value <= 4'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (do_deq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 296:16]
      deq_ptr_value <= _value_T_3; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Decoupled.scala 282:27]
      maybe_full <= 1'h0; // @[src/main/scala/chisel3/util/Decoupled.scala 282:27]
    end else if (do_enq != do_deq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 299:27]
      maybe_full <= do_enq; // @[src/main/scala/chisel3/util/Decoupled.scala 300:16]
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
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram[initvar] = _RAND_0[7:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  enq_ptr_value = _RAND_1[3:0];
  _RAND_2 = {1{`RANDOM}};
  deq_ptr_value = _RAND_2[3:0];
  _RAND_3 = {1{`RANDOM}};
  maybe_full = _RAND_3[0:0];
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
  wire  toSamples_in_q_clock; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
  wire  toSamples_in_q_reset; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
  wire  toSamples_in_q_io_enq_ready; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
  wire  toSamples_in_q_io_enq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
  wire [7:0] toSamples_in_q_io_enq_bits; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
  wire  toSamples_in_q_io_deq_ready; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
  wire  toSamples_in_q_io_deq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
  wire [7:0] toSamples_in_q_io_deq_bits; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
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
  Queue toSamples_in_q ( // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
    .clock(toSamples_in_q_clock),
    .reset(toSamples_in_q_reset),
    .io_enq_ready(toSamples_in_q_io_enq_ready),
    .io_enq_valid(toSamples_in_q_io_enq_valid),
    .io_enq_bits(toSamples_in_q_io_enq_bits),
    .io_deq_ready(toSamples_in_q_io_deq_ready),
    .io_deq_valid(toSamples_in_q_io_deq_valid),
    .io_deq_bits(toSamples_in_q_io_deq_bits)
  );
  assign io_rx_ready = toSamples_in_q_io_enq_ready; // @[src/main/scala/chisel3/util/Decoupled.scala 385:17]
  assign io_tx_valid = toBytes_out_valid; // @[\\src\\main\\scala\\top\\AudioCore.scala 27:15]
  assign io_tx_bits = toBytes_out_bits; // @[\\src\\main\\scala\\top\\AudioCore.scala 27:15]
  assign toSamples_clock = clock;
  assign toSamples_reset = reset;
  assign toSamples_in_valid = toSamples_in_q_io_deq_valid; // @[\\src\\main\\scala\\top\\AudioCore.scala 23:16]
  assign toSamples_in_bits = toSamples_in_q_io_deq_bits; // @[\\src\\main\\scala\\top\\AudioCore.scala 23:16]
  assign toSamples_out_ready = toBytes_in_ready; // @[\\src\\main\\scala\\top\\AudioCore.scala 26:14]
  assign toBytes_clock = clock;
  assign toBytes_reset = reset;
  assign toBytes_in_valid = toSamples_out_valid; // @[\\src\\main\\scala\\top\\AudioCore.scala 26:14]
  assign toBytes_in_bits = toSamples_out_bits; // @[\\src\\main\\scala\\top\\AudioCore.scala 26:14]
  assign toBytes_out_ready = io_tx_ready; // @[\\src\\main\\scala\\top\\AudioCore.scala 27:15]
  assign toSamples_in_q_clock = clock;
  assign toSamples_in_q_reset = reset;
  assign toSamples_in_q_io_enq_valid = io_rx_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 383:22]
  assign toSamples_in_q_io_enq_bits = io_rx_bits; // @[src/main/scala/chisel3/util/Decoupled.scala 384:21]
  assign toSamples_in_q_io_deq_ready = toSamples_in_ready; // @[\\src\\main\\scala\\top\\AudioCore.scala 23:16]
endmodule
module Queue_1(
  input        clock,
  input        reset,
  output       io_enq_ready, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  input        io_enq_valid, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  input  [7:0] io_enq_bits, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  input        io_deq_ready, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  output       io_deq_valid, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  output [7:0] io_deq_bits // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] ram [0:63]; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire  ram_io_deq_bits_MPORT_en; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire [5:0] ram_io_deq_bits_MPORT_addr; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire [7:0] ram_io_deq_bits_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire [7:0] ram_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire [5:0] ram_MPORT_addr; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire  ram_MPORT_mask; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire  ram_MPORT_en; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  reg [5:0] enq_ptr_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg [5:0] deq_ptr_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg  maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 282:27]
  wire  ptr_match = enq_ptr_value == deq_ptr_value; // @[src/main/scala/chisel3/util/Decoupled.scala 283:33]
  wire  empty = ptr_match & ~maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 284:25]
  wire  full = ptr_match & maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 285:24]
  wire  do_enq = io_enq_ready & io_enq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire  do_deq = io_deq_ready & io_deq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire [5:0] _value_T_1 = enq_ptr_value + 6'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire [5:0] _value_T_3 = deq_ptr_value + 6'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  assign ram_io_deq_bits_MPORT_en = 1'h1;
  assign ram_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_io_deq_bits_MPORT_data = ram[ram_io_deq_bits_MPORT_addr]; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  assign ram_MPORT_data = io_enq_bits;
  assign ram_MPORT_addr = enq_ptr_value;
  assign ram_MPORT_mask = 1'h1;
  assign ram_MPORT_en = io_enq_ready & io_enq_valid;
  assign io_enq_ready = ~full; // @[src/main/scala/chisel3/util/Decoupled.scala 309:19]
  assign io_deq_valid = ~empty; // @[src/main/scala/chisel3/util/Decoupled.scala 308:19]
  assign io_deq_bits = ram_io_deq_bits_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 316:17]
  always @(posedge clock) begin
    if (ram_MPORT_en & ram_MPORT_mask) begin
      ram[ram_MPORT_addr] <= ram_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      enq_ptr_value <= 6'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (do_enq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 292:16]
      enq_ptr_value <= _value_T_1; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      deq_ptr_value <= 6'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (do_deq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 296:16]
      deq_ptr_value <= _value_T_3; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Decoupled.scala 282:27]
      maybe_full <= 1'h0; // @[src/main/scala/chisel3/util/Decoupled.scala 282:27]
    end else if (do_enq != do_deq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 299:27]
      maybe_full <= do_enq; // @[src/main/scala/chisel3/util/Decoupled.scala 300:16]
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
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 64; initvar = initvar+1)
    ram[initvar] = _RAND_0[7:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  enq_ptr_value = _RAND_1[5:0];
  _RAND_2 = {1{`RANDOM}};
  deq_ptr_value = _RAND_2[5:0];
  _RAND_3 = {1{`RANDOM}};
  maybe_full = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Top(
  input         clock,
  input         reset,
  input         io_rxd, // @[\\src\\main\\scala\\top\\Top.scala 13:14]
  output        io_txd, // @[\\src\\main\\scala\\top\\Top.scala 13:14]
  input  [15:0] io_sw // @[\\src\\main\\scala\\top\\Top.scala 13:14]
);
  wire  rx_clock; // @[\\src\\main\\scala\\top\\Top.scala 19:18]
  wire  rx_reset; // @[\\src\\main\\scala\\top\\Top.scala 19:18]
  wire  rx_io_rxd; // @[\\src\\main\\scala\\top\\Top.scala 19:18]
  wire  rx_io_channel_ready; // @[\\src\\main\\scala\\top\\Top.scala 19:18]
  wire  rx_io_channel_valid; // @[\\src\\main\\scala\\top\\Top.scala 19:18]
  wire [7:0] rx_io_channel_bits; // @[\\src\\main\\scala\\top\\Top.scala 19:18]
  wire  tx_clock; // @[\\src\\main\\scala\\top\\Top.scala 27:18]
  wire  tx_reset; // @[\\src\\main\\scala\\top\\Top.scala 27:18]
  wire  tx_io_txd; // @[\\src\\main\\scala\\top\\Top.scala 27:18]
  wire  tx_io_channel_ready; // @[\\src\\main\\scala\\top\\Top.scala 27:18]
  wire  tx_io_channel_valid; // @[\\src\\main\\scala\\top\\Top.scala 27:18]
  wire [7:0] tx_io_channel_bits; // @[\\src\\main\\scala\\top\\Top.scala 27:18]
  wire  core_clock; // @[\\src\\main\\scala\\top\\Top.scala 35:20]
  wire  core_reset; // @[\\src\\main\\scala\\top\\Top.scala 35:20]
  wire  core_io_rx_ready; // @[\\src\\main\\scala\\top\\Top.scala 35:20]
  wire  core_io_rx_valid; // @[\\src\\main\\scala\\top\\Top.scala 35:20]
  wire [7:0] core_io_rx_bits; // @[\\src\\main\\scala\\top\\Top.scala 35:20]
  wire  core_io_tx_ready; // @[\\src\\main\\scala\\top\\Top.scala 35:20]
  wire  core_io_tx_valid; // @[\\src\\main\\scala\\top\\Top.scala 35:20]
  wire [7:0] core_io_tx_bits; // @[\\src\\main\\scala\\top\\Top.scala 35:20]
  wire  core_io_rx_q_clock; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
  wire  core_io_rx_q_reset; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
  wire  core_io_rx_q_io_enq_ready; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
  wire  core_io_rx_q_io_enq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
  wire [7:0] core_io_rx_q_io_enq_bits; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
  wire  core_io_rx_q_io_deq_ready; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
  wire  core_io_rx_q_io_deq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
  wire [7:0] core_io_rx_q_io_deq_bits; // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
  Rx rx ( // @[\\src\\main\\scala\\top\\Top.scala 19:18]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_rxd(rx_io_rxd),
    .io_channel_ready(rx_io_channel_ready),
    .io_channel_valid(rx_io_channel_valid),
    .io_channel_bits(rx_io_channel_bits)
  );
  UartTx tx ( // @[\\src\\main\\scala\\top\\Top.scala 27:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  AudioCore core ( // @[\\src\\main\\scala\\top\\Top.scala 35:20]
    .clock(core_clock),
    .reset(core_reset),
    .io_rx_ready(core_io_rx_ready),
    .io_rx_valid(core_io_rx_valid),
    .io_rx_bits(core_io_rx_bits),
    .io_tx_ready(core_io_tx_ready),
    .io_tx_valid(core_io_tx_valid),
    .io_tx_bits(core_io_tx_bits)
  );
  Queue_1 core_io_rx_q ( // @[src/main/scala/chisel3/util/Decoupled.scala 381:21]
    .clock(core_io_rx_q_clock),
    .reset(core_io_rx_q_reset),
    .io_enq_ready(core_io_rx_q_io_enq_ready),
    .io_enq_valid(core_io_rx_q_io_enq_valid),
    .io_enq_bits(core_io_rx_q_io_enq_bits),
    .io_deq_ready(core_io_rx_q_io_deq_ready),
    .io_deq_valid(core_io_rx_q_io_deq_valid),
    .io_deq_bits(core_io_rx_q_io_deq_bits)
  );
  assign io_txd = tx_io_txd; // @[\\src\\main\\scala\\top\\Top.scala 33:10]
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_rxd = io_rxd; // @[\\src\\main\\scala\\top\\Top.scala 25:13]
  assign rx_io_channel_ready = core_io_rx_q_io_enq_ready; // @[src/main/scala/chisel3/util/Decoupled.scala 385:17]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = core_io_tx_valid; // @[\\src\\main\\scala\\top\\Top.scala 39:17]
  assign tx_io_channel_bits = core_io_tx_bits; // @[\\src\\main\\scala\\top\\Top.scala 39:17]
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_rx_valid = core_io_rx_q_io_deq_valid; // @[\\src\\main\\scala\\top\\Top.scala 38:14]
  assign core_io_rx_bits = core_io_rx_q_io_deq_bits; // @[\\src\\main\\scala\\top\\Top.scala 38:14]
  assign core_io_tx_ready = tx_io_channel_ready; // @[\\src\\main\\scala\\top\\Top.scala 39:17]
  assign core_io_rx_q_clock = clock;
  assign core_io_rx_q_reset = reset;
  assign core_io_rx_q_io_enq_valid = rx_io_channel_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 383:22]
  assign core_io_rx_q_io_enq_bits = rx_io_channel_bits; // @[src/main/scala/chisel3/util/Decoupled.scala 384:21]
  assign core_io_rx_q_io_deq_ready = core_io_rx_ready; // @[\\src\\main\\scala\\top\\Top.scala 38:14]
endmodule
