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
module Buffer(
  input        clock,
  input        reset,
  output       io_in_ready, // @[src/main/scala/chisel/lib/uart/Uart.scala 111:14]
  input        io_in_valid, // @[src/main/scala/chisel/lib/uart/Uart.scala 111:14]
  input  [7:0] io_in_bits, // @[src/main/scala/chisel/lib/uart/Uart.scala 111:14]
  input        io_out_ready, // @[src/main/scala/chisel/lib/uart/Uart.scala 111:14]
  output       io_out_valid, // @[src/main/scala/chisel/lib/uart/Uart.scala 111:14]
  output [7:0] io_out_bits // @[src/main/scala/chisel/lib/uart/Uart.scala 111:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg  stateReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 117:25]
  reg [7:0] dataReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 118:24]
  wire  _io_in_ready_T = ~stateReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 120:27]
  wire  _GEN_1 = io_in_valid | stateReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 124:23 126:16 117:25]
  assign io_in_ready = ~stateReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 120:27]
  assign io_out_valid = stateReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 121:28]
  assign io_out_bits = dataReg; // @[src/main/scala/chisel/lib/uart/Uart.scala 133:15]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 117:25]
      stateReg <= 1'h0; // @[src/main/scala/chisel/lib/uart/Uart.scala 117:25]
    end else if (_io_in_ready_T) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 123:28]
      stateReg <= _GEN_1;
    end else if (io_out_ready) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 129:24]
      stateReg <= 1'h0; // @[src/main/scala/chisel/lib/uart/Uart.scala 130:16]
    end
    if (reset) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 118:24]
      dataReg <= 8'h0; // @[src/main/scala/chisel/lib/uart/Uart.scala 118:24]
    end else if (_io_in_ready_T) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 123:28]
      if (io_in_valid) begin // @[src/main/scala/chisel/lib/uart/Uart.scala 124:23]
        dataReg <= io_in_bits; // @[src/main/scala/chisel/lib/uart/Uart.scala 125:15]
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
  stateReg = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  dataReg = _RAND_1[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BufferedTx(
  input        clock,
  input        reset,
  output       io_txd, // @[src/main/scala/chisel/lib/uart/Uart.scala 140:14]
  output       io_channel_ready, // @[src/main/scala/chisel/lib/uart/Uart.scala 140:14]
  input        io_channel_valid, // @[src/main/scala/chisel/lib/uart/Uart.scala 140:14]
  input  [7:0] io_channel_bits // @[src/main/scala/chisel/lib/uart/Uart.scala 140:14]
);
  wire  tx_clock; // @[src/main/scala/chisel/lib/uart/Uart.scala 144:18]
  wire  tx_reset; // @[src/main/scala/chisel/lib/uart/Uart.scala 144:18]
  wire  tx_io_txd; // @[src/main/scala/chisel/lib/uart/Uart.scala 144:18]
  wire  tx_io_channel_ready; // @[src/main/scala/chisel/lib/uart/Uart.scala 144:18]
  wire  tx_io_channel_valid; // @[src/main/scala/chisel/lib/uart/Uart.scala 144:18]
  wire [7:0] tx_io_channel_bits; // @[src/main/scala/chisel/lib/uart/Uart.scala 144:18]
  wire  buf__clock; // @[src/main/scala/chisel/lib/uart/Uart.scala 145:19]
  wire  buf__reset; // @[src/main/scala/chisel/lib/uart/Uart.scala 145:19]
  wire  buf__io_in_ready; // @[src/main/scala/chisel/lib/uart/Uart.scala 145:19]
  wire  buf__io_in_valid; // @[src/main/scala/chisel/lib/uart/Uart.scala 145:19]
  wire [7:0] buf__io_in_bits; // @[src/main/scala/chisel/lib/uart/Uart.scala 145:19]
  wire  buf__io_out_ready; // @[src/main/scala/chisel/lib/uart/Uart.scala 145:19]
  wire  buf__io_out_valid; // @[src/main/scala/chisel/lib/uart/Uart.scala 145:19]
  wire [7:0] buf__io_out_bits; // @[src/main/scala/chisel/lib/uart/Uart.scala 145:19]
  Tx tx ( // @[src/main/scala/chisel/lib/uart/Uart.scala 144:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  Buffer buf_ ( // @[src/main/scala/chisel/lib/uart/Uart.scala 145:19]
    .clock(buf__clock),
    .reset(buf__reset),
    .io_in_ready(buf__io_in_ready),
    .io_in_valid(buf__io_in_valid),
    .io_in_bits(buf__io_in_bits),
    .io_out_ready(buf__io_out_ready),
    .io_out_valid(buf__io_out_valid),
    .io_out_bits(buf__io_out_bits)
  );
  assign io_txd = tx_io_txd; // @[src/main/scala/chisel/lib/uart/Uart.scala 149:10]
  assign io_channel_ready = buf__io_in_ready; // @[src/main/scala/chisel/lib/uart/Uart.scala 147:13]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = buf__io_out_valid; // @[src/main/scala/chisel/lib/uart/Uart.scala 148:17]
  assign tx_io_channel_bits = buf__io_out_bits; // @[src/main/scala/chisel/lib/uart/Uart.scala 148:17]
  assign buf__clock = clock;
  assign buf__reset = reset;
  assign buf__io_in_valid = io_channel_valid; // @[src/main/scala/chisel/lib/uart/Uart.scala 147:13]
  assign buf__io_in_bits = io_channel_bits; // @[src/main/scala/chisel/lib/uart/Uart.scala 147:13]
  assign buf__io_out_ready = tx_io_channel_ready; // @[src/main/scala/chisel/lib/uart/Uart.scala 148:17]
endmodule
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
module Echo(
  input   clock,
  input   reset,
  output  io_txd, // @[src/main/scala/chisel/lib/uart/Uart.scala 179:14]
  input   io_rxd // @[src/main/scala/chisel/lib/uart/Uart.scala 179:14]
);
  wire  tx_clock; // @[src/main/scala/chisel/lib/uart/Uart.scala 184:18]
  wire  tx_reset; // @[src/main/scala/chisel/lib/uart/Uart.scala 184:18]
  wire  tx_io_txd; // @[src/main/scala/chisel/lib/uart/Uart.scala 184:18]
  wire  tx_io_channel_ready; // @[src/main/scala/chisel/lib/uart/Uart.scala 184:18]
  wire  tx_io_channel_valid; // @[src/main/scala/chisel/lib/uart/Uart.scala 184:18]
  wire [7:0] tx_io_channel_bits; // @[src/main/scala/chisel/lib/uart/Uart.scala 184:18]
  wire  rx_clock; // @[src/main/scala/chisel/lib/uart/Uart.scala 185:18]
  wire  rx_reset; // @[src/main/scala/chisel/lib/uart/Uart.scala 185:18]
  wire  rx_io_rxd; // @[src/main/scala/chisel/lib/uart/Uart.scala 185:18]
  wire  rx_io_channel_ready; // @[src/main/scala/chisel/lib/uart/Uart.scala 185:18]
  wire  rx_io_channel_valid; // @[src/main/scala/chisel/lib/uart/Uart.scala 185:18]
  wire [7:0] rx_io_channel_bits; // @[src/main/scala/chisel/lib/uart/Uart.scala 185:18]
  BufferedTx tx ( // @[src/main/scala/chisel/lib/uart/Uart.scala 184:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  Rx rx ( // @[src/main/scala/chisel/lib/uart/Uart.scala 185:18]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_rxd(rx_io_rxd),
    .io_channel_ready(rx_io_channel_ready),
    .io_channel_valid(rx_io_channel_valid),
    .io_channel_bits(rx_io_channel_bits)
  );
  assign io_txd = tx_io_txd; // @[src/main/scala/chisel/lib/uart/Uart.scala 186:10]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = rx_io_channel_valid; // @[src/main/scala/chisel/lib/uart/Uart.scala 188:17]
  assign tx_io_channel_bits = rx_io_channel_bits; // @[src/main/scala/chisel/lib/uart/Uart.scala 188:17]
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_rxd = io_rxd; // @[src/main/scala/chisel/lib/uart/Uart.scala 187:13]
  assign rx_io_channel_ready = tx_io_channel_ready; // @[src/main/scala/chisel/lib/uart/Uart.scala 188:17]
endmodule
module EchoDemo(
  input   clock,
  input   reset,
  output  io_tx, // @[\\src\\main\\scala\\serial\\EchoDemo.scala 8:14]
  input   io_rx // @[\\src\\main\\scala\\serial\\EchoDemo.scala 8:14]
);
  wire  uart_clock; // @[\\src\\main\\scala\\serial\\EchoDemo.scala 13:20]
  wire  uart_reset; // @[\\src\\main\\scala\\serial\\EchoDemo.scala 13:20]
  wire  uart_io_txd; // @[\\src\\main\\scala\\serial\\EchoDemo.scala 13:20]
  wire  uart_io_rxd; // @[\\src\\main\\scala\\serial\\EchoDemo.scala 13:20]
  Echo uart ( // @[\\src\\main\\scala\\serial\\EchoDemo.scala 13:20]
    .clock(uart_clock),
    .reset(uart_reset),
    .io_txd(uart_io_txd),
    .io_rxd(uart_io_rxd)
  );
  assign io_tx = uart_io_txd; // @[\\src\\main\\scala\\serial\\EchoDemo.scala 16:24]
  assign uart_clock = clock;
  assign uart_reset = reset;
  assign uart_io_rxd = io_rx; // @[\\src\\main\\scala\\serial\\EchoDemo.scala 17:15]
endmodule
