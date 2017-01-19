require_relative "helper"

module Risc
  class IfSimpleTest < MiniTest::Test
    include Ticker
    include Compiling

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

    def test_if
        #show_ticks # get output of what is
        check_chain [Branch, Label, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, RegToSlot, FunctionCall, Label, LoadConstant,
             LoadConstant, OperatorInstruction, IsZero, SlotToReg, LoadConstant,
             RegToSlot, LoadConstant, RegToSlot, LoadConstant, SlotToReg,
             RegToSlot, LoadConstant, RegToSlot, RiscTransfer, FunctionCall,
             Label, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, RiscTransfer, Syscall, RiscTransfer, RiscTransfer,
             RegToSlot, Label, FunctionReturn, RiscTransfer, SlotToReg,
             SlotToReg, Branch, Label, LoadConstant, SlotToReg,
             RegToSlot, Label, FunctionReturn, RiscTransfer, Syscall,
             NilClass]
    end
  end
end
