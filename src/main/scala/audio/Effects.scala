package audio

import chisel3._
import chisel3.util._
import utils._

import util._

class Gain()(implicit params: AudioParams) extends AudioEffect() {
    val processingSample = Reg(SInt(sampleIn.getWidth.W))
    val gainIn = switches.gain
    // val added = processingSample + gainIn
    // val subbed = processingSample - gainIn
    val isNeg = processingSample(processingSample.getWidth - 1)
    val gainedSample = // check if sample is negative, then we subtract otherwise add
      Mux(isNeg, processingSample - gainIn,processingSample + gainIn)
    val differ = processingSample =/= sampleIn

    object S extends ChiselEnum {val calc, ready = Value}
    val state = RegInit(S.calc)
    switch(state){
        is(S.calc) {
            processingDone := false.B
            processedSample := SampleHelper.saturate(gainedSample)
            state := S.ready
        }
        is(S.ready) {
            processingDone := true.B
            when(differ) {
                processingSample := sampleIn
                state := S.calc
            }
        }
    }
}
