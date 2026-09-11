FIRRTL version 1.2.0
circuit SerialPort :
  module Tx :
    input clock : Clock
    input reset : Reset
    output io : { txd : UInt<1>, flip channel : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}} @[src/main/scala/chisel/lib/uart/Uart.scala 23:14]

    reg shiftReg : UInt, clock with :
      reset => (reset, UInt<11>("h7ff")) @[src/main/scala/chisel/lib/uart/Uart.scala 30:25]
    reg cntReg : UInt<20>, clock with :
      reset => (reset, UInt<20>("h0")) @[src/main/scala/chisel/lib/uart/Uart.scala 31:23]
    reg bitsReg : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[src/main/scala/chisel/lib/uart/Uart.scala 32:24]
    node _io_channel_ready_T = eq(cntReg, UInt<1>("h0")) @[src/main/scala/chisel/lib/uart/Uart.scala 34:31]
    node _io_channel_ready_T_1 = eq(bitsReg, UInt<1>("h0")) @[src/main/scala/chisel/lib/uart/Uart.scala 34:52]
    node _io_channel_ready_T_2 = and(_io_channel_ready_T, _io_channel_ready_T_1) @[src/main/scala/chisel/lib/uart/Uart.scala 34:40]
    io.channel.ready <= _io_channel_ready_T_2 @[src/main/scala/chisel/lib/uart/Uart.scala 34:20]
    node _io_txd_T = bits(shiftReg, 0, 0) @[src/main/scala/chisel/lib/uart/Uart.scala 35:21]
    io.txd <= _io_txd_T @[src/main/scala/chisel/lib/uart/Uart.scala 35:10]
    node _T = eq(cntReg, UInt<1>("h0")) @[src/main/scala/chisel/lib/uart/Uart.scala 37:15]
    when _T : @[src/main/scala/chisel/lib/uart/Uart.scala 37:24]
      cntReg <= UInt<10>("h363") @[src/main/scala/chisel/lib/uart/Uart.scala 39:12]
      node _T_1 = neq(bitsReg, UInt<1>("h0")) @[src/main/scala/chisel/lib/uart/Uart.scala 40:18]
      when _T_1 : @[src/main/scala/chisel/lib/uart/Uart.scala 40:27]
        node shift = shr(shiftReg, 1) @[src/main/scala/chisel/lib/uart/Uart.scala 41:28]
        node _shiftReg_T = bits(shift, 9, 0) @[src/main/scala/chisel/lib/uart/Uart.scala 42:33]
        node _shiftReg_T_1 = cat(UInt<1>("h1"), _shiftReg_T) @[src/main/scala/chisel/lib/uart/Uart.scala 42:22]
        shiftReg <= _shiftReg_T_1 @[src/main/scala/chisel/lib/uart/Uart.scala 42:16]
        node _bitsReg_T = sub(bitsReg, UInt<1>("h1")) @[src/main/scala/chisel/lib/uart/Uart.scala 43:26]
        node _bitsReg_T_1 = tail(_bitsReg_T, 1) @[src/main/scala/chisel/lib/uart/Uart.scala 43:26]
        bitsReg <= _bitsReg_T_1 @[src/main/scala/chisel/lib/uart/Uart.scala 43:15]
      else :
        when io.channel.valid : @[src/main/scala/chisel/lib/uart/Uart.scala 45:30]
          node _shiftReg_T_2 = cat(UInt<2>("h3"), io.channel.bits) @[src/main/scala/chisel/lib/uart/Uart.scala 46:28]
          node _shiftReg_T_3 = cat(_shiftReg_T_2, UInt<1>("h0")) @[src/main/scala/chisel/lib/uart/Uart.scala 46:24]
          shiftReg <= _shiftReg_T_3 @[src/main/scala/chisel/lib/uart/Uart.scala 46:18]
          bitsReg <= UInt<4>("hb") @[src/main/scala/chisel/lib/uart/Uart.scala 47:17]
        else :
          shiftReg <= UInt<11>("h7ff") @[src/main/scala/chisel/lib/uart/Uart.scala 49:18]
    else :
      node _cntReg_T = sub(cntReg, UInt<1>("h1")) @[src/main/scala/chisel/lib/uart/Uart.scala 54:22]
      node _cntReg_T_1 = tail(_cntReg_T, 1) @[src/main/scala/chisel/lib/uart/Uart.scala 54:22]
      cntReg <= _cntReg_T_1 @[src/main/scala/chisel/lib/uart/Uart.scala 54:12]


  module Buffer :
    input clock : Clock
    input reset : Reset
    output io : { flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}} @[src/main/scala/chisel/lib/uart/Uart.scala 111:14]

    reg stateReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[src/main/scala/chisel/lib/uart/Uart.scala 117:25]
    reg dataReg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[src/main/scala/chisel/lib/uart/Uart.scala 118:24]
    node _io_in_ready_T = eq(stateReg, UInt<1>("h0")) @[src/main/scala/chisel/lib/uart/Uart.scala 120:27]
    io.in.ready <= _io_in_ready_T @[src/main/scala/chisel/lib/uart/Uart.scala 120:15]
    node _io_out_valid_T = eq(stateReg, UInt<1>("h1")) @[src/main/scala/chisel/lib/uart/Uart.scala 121:28]
    io.out.valid <= _io_out_valid_T @[src/main/scala/chisel/lib/uart/Uart.scala 121:16]
    node _T = eq(stateReg, UInt<1>("h0")) @[src/main/scala/chisel/lib/uart/Uart.scala 123:17]
    when _T : @[src/main/scala/chisel/lib/uart/Uart.scala 123:28]
      when io.in.valid : @[src/main/scala/chisel/lib/uart/Uart.scala 124:23]
        dataReg <= io.in.bits @[src/main/scala/chisel/lib/uart/Uart.scala 125:15]
        stateReg <= UInt<1>("h1") @[src/main/scala/chisel/lib/uart/Uart.scala 126:16]
    else :
      when io.out.ready : @[src/main/scala/chisel/lib/uart/Uart.scala 129:24]
        stateReg <= UInt<1>("h0") @[src/main/scala/chisel/lib/uart/Uart.scala 130:16]
    io.out.bits <= dataReg @[src/main/scala/chisel/lib/uart/Uart.scala 133:15]

  module BufferedTx :
    input clock : Clock
    input reset : Reset
    output io : { txd : UInt<1>, flip channel : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}} @[src/main/scala/chisel/lib/uart/Uart.scala 140:14]

    inst tx of Tx @[src/main/scala/chisel/lib/uart/Uart.scala 144:18]
    tx.clock <= clock
    tx.reset <= reset
    inst buf of Buffer @[src/main/scala/chisel/lib/uart/Uart.scala 145:19]
    buf.clock <= clock
    buf.reset <= reset
    buf.io.in <= io.channel @[src/main/scala/chisel/lib/uart/Uart.scala 147:13]
    tx.io.channel <= buf.io.out @[src/main/scala/chisel/lib/uart/Uart.scala 148:17]
    io.txd <= tx.io.txd @[src/main/scala/chisel/lib/uart/Uart.scala 149:10]

  module SerialPort :
    input clock : Clock
    input reset : UInt<1>
    output io : { tx : UInt<1>, led : UInt<1>} @[\\src\\main\\scala\\serial\\SerialPort.scala 8:14]

    inst uart of BufferedTx @[\\src\\main\\scala\\serial\\SerialPort.scala 16:20]
    uart.clock <= clock
    uart.reset <= reset
    reg cntr : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[\\src\\main\\scala\\serial\\SerialPort.scala 20:21]
    reg cntr_time : UInt<27>, clock with :
      reset => (reset, UInt<27>("h0")) @[\\src\\main\\scala\\serial\\SerialPort.scala 21:26]
    wire hello : UInt<7>[13] @[\\src\\main\\scala\\serial\\SerialPort.scala 24:22]
    hello[0] <= UInt<7>("h48") @[\\src\\main\\scala\\serial\\SerialPort.scala 24:22]
    hello[1] <= UInt<7>("h65") @[\\src\\main\\scala\\serial\\SerialPort.scala 24:22]
    hello[2] <= UInt<7>("h6c") @[\\src\\main\\scala\\serial\\SerialPort.scala 24:22]
    hello[3] <= UInt<7>("h6c") @[\\src\\main\\scala\\serial\\SerialPort.scala 24:22]
    hello[4] <= UInt<7>("h6f") @[\\src\\main\\scala\\serial\\SerialPort.scala 24:22]
    hello[5] <= UInt<6>("h20") @[\\src\\main\\scala\\serial\\SerialPort.scala 24:22]
    hello[6] <= UInt<7>("h57") @[\\src\\main\\scala\\serial\\SerialPort.scala 24:22]
    hello[7] <= UInt<7>("h6f") @[\\src\\main\\scala\\serial\\SerialPort.scala 24:22]
    hello[8] <= UInt<7>("h72") @[\\src\\main\\scala\\serial\\SerialPort.scala 24:22]
    hello[9] <= UInt<7>("h6c") @[\\src\\main\\scala\\serial\\SerialPort.scala 24:22]
    hello[10] <= UInt<7>("h64") @[\\src\\main\\scala\\serial\\SerialPort.scala 24:22]
    hello[11] <= UInt<6>("h21") @[\\src\\main\\scala\\serial\\SerialPort.scala 24:22]
    hello[12] <= UInt<4>("ha") @[\\src\\main\\scala\\serial\\SerialPort.scala 24:22]
    node message_sending = neq(cntr, UInt<4>("hc")) @[\\src\\main\\scala\\serial\\SerialPort.scala 40:30]
    uart.io.channel.bits <= hello[cntr] @[\\src\\main\\scala\\serial\\SerialPort.scala 42:24]
    when message_sending : @[\\src\\main\\scala\\serial\\SerialPort.scala 43:25]
      when uart.io.channel.ready : @[\\src\\main\\scala\\serial\\SerialPort.scala 44:33]
        node _cntr_T = add(cntr, UInt<1>("h1")) @[\\src\\main\\scala\\serial\\SerialPort.scala 45:20]
        node _cntr_T_1 = tail(_cntr_T, 1) @[\\src\\main\\scala\\serial\\SerialPort.scala 45:20]
        cntr <= _cntr_T_1 @[\\src\\main\\scala\\serial\\SerialPort.scala 45:12]
      io.led <= UInt<1>("h1") @[\\src\\main\\scala\\serial\\SerialPort.scala 47:12]
    else :
      node _T = eq(cntr_time, UInt<27>("h5f5e100")) @[\\src\\main\\scala\\serial\\SerialPort.scala 49:20]
      when _T : @[\\src\\main\\scala\\serial\\SerialPort.scala 49:33]
        cntr <= UInt<1>("h0") @[\\src\\main\\scala\\serial\\SerialPort.scala 50:12]
        cntr_time <= UInt<1>("h0") @[\\src\\main\\scala\\serial\\SerialPort.scala 51:17]
      else :
        node _cntr_time_T = add(cntr_time, UInt<1>("h1")) @[\\src\\main\\scala\\serial\\SerialPort.scala 53:30]
        node _cntr_time_T_1 = tail(_cntr_time_T, 1) @[\\src\\main\\scala\\serial\\SerialPort.scala 53:30]
        cntr_time <= _cntr_time_T_1 @[\\src\\main\\scala\\serial\\SerialPort.scala 53:17]
      io.led <= UInt<1>("h0") @[\\src\\main\\scala\\serial\\SerialPort.scala 55:12]
    uart.io.channel.valid <= message_sending @[\\src\\main\\scala\\serial\\SerialPort.scala 58:25]
    node _io_tx_T = bits(uart.io.txd, 0, 0) @[\\src\\main\\scala\\serial\\SerialPort.scala 60:24]
    io.tx <= _io_tx_T @[\\src\\main\\scala\\serial\\SerialPort.scala 60:9]

