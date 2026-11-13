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
module SamplesToBytes(
  input        clock,
  input        reset,
  input        out_ready, // @[\\src\\main\\scala\\audio\\SampleCodec.scala 42:15]
  output       out_valid, // @[\\src\\main\\scala\\audio\\SampleCodec.scala 42:15]
  output [7:0] out_bits // @[\\src\\main\\scala\\audio\\SampleCodec.scala 42:15]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [15:0] shift; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 44:22]
  reg [1:0] counter; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 45:24]
  wire  empty = counter == 2'h0; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 46:23]
  wire  _T_1 = out_ready & out_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire [1:0] _counter_T_1 = counter - 2'h1; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 57:24]
  assign out_valid = ~empty; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 49:16]
  assign out_bits = shift[7:0]; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 50:20]
  always @(posedge clock) begin
    if (reset) begin // @[\\src\\main\\scala\\audio\\SampleCodec.scala 44:22]
      shift <= 16'h0; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 44:22]
    end else if (_T_1) begin // @[\\src\\main\\scala\\audio\\SampleCodec.scala 55:25]
      shift <= {{8'd0}, shift[15:8]}; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 56:11]
    end
    if (reset) begin // @[\\src\\main\\scala\\audio\\SampleCodec.scala 45:24]
      counter <= 2'h0; // @[\\src\\main\\scala\\audio\\SampleCodec.scala 45:24]
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
  input        io_tx_ready, // @[\\src\\main\\scala\\top\\AudioCore.scala 13:14]
  output       io_tx_valid, // @[\\src\\main\\scala\\top\\AudioCore.scala 13:14]
  output [7:0] io_tx_bits // @[\\src\\main\\scala\\top\\AudioCore.scala 13:14]
);
  wire  toBytes_clock; // @[\\src\\main\\scala\\top\\AudioCore.scala 24:23]
  wire  toBytes_reset; // @[\\src\\main\\scala\\top\\AudioCore.scala 24:23]
  wire  toBytes_out_ready; // @[\\src\\main\\scala\\top\\AudioCore.scala 24:23]
  wire  toBytes_out_valid; // @[\\src\\main\\scala\\top\\AudioCore.scala 24:23]
  wire [7:0] toBytes_out_bits; // @[\\src\\main\\scala\\top\\AudioCore.scala 24:23]
  SamplesToBytes toBytes ( // @[\\src\\main\\scala\\top\\AudioCore.scala 24:23]
    .clock(toBytes_clock),
    .reset(toBytes_reset),
    .out_ready(toBytes_out_ready),
    .out_valid(toBytes_out_valid),
    .out_bits(toBytes_out_bits)
  );
  assign io_tx_valid = toBytes_out_valid; // @[\\src\\main\\scala\\top\\AudioCore.scala 34:15]
  assign io_tx_bits = toBytes_out_bits; // @[\\src\\main\\scala\\top\\AudioCore.scala 34:15]
  assign toBytes_clock = clock;
  assign toBytes_reset = reset;
  assign toBytes_out_ready = io_tx_ready; // @[\\src\\main\\scala\\top\\AudioCore.scala 34:15]
endmodule
module Top(
  input         clock,
  input         reset,
  input         io_rxd, // @[\\src\\main\\scala\\top\\Top.scala 13:14]
  output        io_txd, // @[\\src\\main\\scala\\top\\Top.scala 13:14]
  input  [15:0] io_sw // @[\\src\\main\\scala\\top\\Top.scala 13:14]
);
  wire  tx_clock; // @[\\src\\main\\scala\\top\\Top.scala 27:18]
  wire  tx_reset; // @[\\src\\main\\scala\\top\\Top.scala 27:18]
  wire  tx_io_txd; // @[\\src\\main\\scala\\top\\Top.scala 27:18]
  wire  tx_io_channel_ready; // @[\\src\\main\\scala\\top\\Top.scala 27:18]
  wire  tx_io_channel_valid; // @[\\src\\main\\scala\\top\\Top.scala 27:18]
  wire [7:0] tx_io_channel_bits; // @[\\src\\main\\scala\\top\\Top.scala 27:18]
  wire  core_clock; // @[\\src\\main\\scala\\top\\Top.scala 35:20]
  wire  core_reset; // @[\\src\\main\\scala\\top\\Top.scala 35:20]
  wire  core_io_tx_ready; // @[\\src\\main\\scala\\top\\Top.scala 35:20]
  wire  core_io_tx_valid; // @[\\src\\main\\scala\\top\\Top.scala 35:20]
  wire [7:0] core_io_tx_bits; // @[\\src\\main\\scala\\top\\Top.scala 35:20]
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
    .io_tx_ready(core_io_tx_ready),
    .io_tx_valid(core_io_tx_valid),
    .io_tx_bits(core_io_tx_bits)
  );
  assign io_txd = tx_io_txd; // @[\\src\\main\\scala\\top\\Top.scala 33:10]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = core_io_tx_valid; // @[\\src\\main\\scala\\top\\Top.scala 39:17]
  assign tx_io_channel_bits = core_io_tx_bits; // @[\\src\\main\\scala\\top\\Top.scala 39:17]
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_tx_ready = tx_io_channel_ready; // @[\\src\\main\\scala\\top\\Top.scala 39:17]
endmodule
