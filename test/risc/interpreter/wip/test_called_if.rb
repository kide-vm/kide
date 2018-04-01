require_relative "../helper"

module Risc
  class IfCalledTest < MiniTest::Test
    include Ticker
    include CleanCompile

    def setup
      @string_input = <<HERE
  class Space
    int itest(int n)
      if_zero( n - 12)
        "then".putstring()
      else
        "else".putstring()
      end
    end

    int main()
      itest(20)
    end
  end
HERE
      @input = s(:statements, s(:call, :itest , s(:arguments, s(:int, 20))))
      super
    end

    # must be after boot, but before main compile, to define method
    def do_clean_compile
      clean_compile :Space , :itest , {:n => :Integer} ,
            s(:statements, s(:if_statement, :zero, s(:condition, s(:operator_value, :-, s(:arg, :n), s(:int, 12))),
                    s(:true_statements, s(:call, :putstring , s(:arguments), s(:receiver, s(:string, "then")))),
                    s(:false_statements, s(:call, :putstring , s(:arguments), s(:receiver, s(:string, "else"))))))
    end
    def pest_if
        #show_ticks # get output of what is
        check_chain [Branch, Label, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, RegToSlot, FunctionCall, Label, SlotToReg,
             SlotToReg, RegToSlot, LoadConstant, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, RegToSlot, Transfer, FunctionCall, Label,
             LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             LoadConstant, OperatorInstruction, IsZero, SlotToReg, LoadConstant,
             RegToSlot, LoadConstant, RegToSlot, LoadConstant, SlotToReg,
             RegToSlot, LoadConstant, RegToSlot, Transfer, FunctionCall,
             Label, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, Transfer, Syscall, Transfer, Transfer,
             RegToSlot, Label, FunctionReturn, Transfer, SlotToReg,
             SlotToReg, Branch, Label, Label, FunctionReturn,
             Transfer, SlotToReg, SlotToReg, LoadConstant, SlotToReg,
             RegToSlot, Label, FunctionReturn, Transfer, Syscall,
             NilClass]
    end
  end
end
