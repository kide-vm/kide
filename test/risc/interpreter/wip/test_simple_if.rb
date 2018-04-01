require_relative "../helper"

module Risc
  class IfSimpleTest < MiniTest::Test
    include Ticker
    include CleanCompile

    def setup
      @string_input = <<HERE
  class Space
    int main()
      if_zero( 10 - 12)
        "then".putstring()
      else
        "else".putstring()
      end
    end
  end
HERE
      @input =  s(:statements, s(:if_statement, :zero, s(:condition, s(:operator_value, :-, s(:int, 10), s(:int, 12))),
                  s(:true_statements, s(:call, :putstring, s(:arguments), s(:receiver, s(:string, "then")))),
                  s(:false_statements, s(:call, :putstring, s(:arguments), s(:receiver, s(:string, "else"))))))

      super
    end

    def pest_if
        #show_ticks # get output of what is
        check_chain [Branch, Label, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, RegToSlot, FunctionCall, Label, LoadConstant,
             LoadConstant, OperatorInstruction, IsZero, SlotToReg, LoadConstant,
             RegToSlot, LoadConstant, RegToSlot, LoadConstant, SlotToReg,
             RegToSlot, LoadConstant, RegToSlot, Transfer, FunctionCall,
             Label, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, Transfer, Syscall, Transfer, Transfer,
             RegToSlot, Label, FunctionReturn, Transfer, SlotToReg,
             SlotToReg, Branch, Label, LoadConstant, SlotToReg,
             RegToSlot, Label, FunctionReturn, Transfer, Syscall,
             NilClass]
    end
  end
end
