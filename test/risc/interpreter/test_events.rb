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
    def length
      94
    end
    def test_state_change
      @interpreter.register_event :state_changed , self
      ticks length
      assert @state_events[:state_changed]
      assert_equal 2 ,  @state_events[:state_changed].length
      assert_equal :running,  @state_events[:state_changed][0]
      @interpreter.unregister_event :state_changed , self
    end

    def test_instruction_events
      @interpreter.register_event :instruction_changed , self
      ticks length
      assert_equal length ,  @instruction_events.length
      @interpreter.unregister_event :instruction_changed , self
    end

    def test_chain
      #show_ticks # get output of what is
      check_chain [Branch, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
             LoadConstant, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, Branch,
             SlotToReg, RegToSlot, SlotToReg, RegToSlot, SlotToReg,
             RegToSlot, SlotToReg, RegToSlot, LoadConstant, RegToSlot,
             FunctionCall, LoadConstant, LoadConstant, SlotToReg, RegToSlot,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, RegToSlot, Branch,
             SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, Branch, FunctionCall,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             OperatorInstruction, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
             RegToSlot, RegToSlot, SlotToReg, Branch, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, SlotToReg, Branch, FunctionReturn, Transfer,
             SlotToReg, Branch, SlotToReg, Syscall, NilClass]
      assert_equal Fixnum , get_return.class
      assert_equal 12 , get_return
    end
    def test_length
      run_all
      assert_equal length , @interpreter.clock
    end
  end
end
