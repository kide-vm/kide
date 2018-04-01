require_relative "helper"

module Risc
  class InterpreterEvents < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 5 + 7")
      @state_events = {}
      @instruction_events = []
      super
    end

    def state_changed( a , b)
      @state_events[:state_changed] = [a , b]
    end

    def instruction_changed(was , is )
      @instruction_events << was
    end

    def test_state_change
      @interpreter.register_event :state_changed , self
      ticks 88
      assert @state_events[:state_changed]
      assert_equal 2 ,  @state_events[:state_changed].length
      assert_equal :running,  @state_events[:state_changed][0]
      @interpreter.unregister_event :state_changed , self
    end

    def test_instruction_events
      @interpreter.register_event :instruction_changed , self
      ticks 88
      assert_equal 88 ,  @instruction_events.length
      @interpreter.unregister_event :instruction_changed , self
    end

    def test_chain
      #show_ticks # get output of what is
      check_chain [Branch, Label, LoadConstant, SlotToReg, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, RegToSlot, LoadConstant, RegToSlot, FunctionCall,
             Label, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, LoadConstant, FunctionCall,
             Label, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, OperatorInstruction, LoadConstant, SlotToReg, SlotToReg,
             RegToSlot, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, FunctionReturn, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             FunctionReturn, Transfer, Syscall, NilClass]
      assert_equal Parfait::Integer , get_return.class
      assert_equal 12 , get_return.value
    end

  end
end
