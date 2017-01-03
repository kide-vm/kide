require_relative "helper"

module Register
  class AddChange < MiniTest::Test
    include Ticker

    def setup
      @input = s(:statements, s(:return, s(:operator_value, :+, s(:int, 5), s(:int, 7))))
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
      ticks 30
      assert @state_events[:state_changed]
      assert_equal 2 ,  @state_events[:state_changed].length
      assert_equal :running,  @state_events[:state_changed][0]
      @interpreter.unregister_event :state_changed , self
    end

    def test_instruction_events
      @interpreter.register_event :instruction_changed , self
      ticks 30
      assert_equal 17 ,  @instruction_events.length
      @interpreter.unregister_event :instruction_changed , self
    end

    def test_chain
      #show_ticks # get output of what is
      check_chain ["Branch","Label","LoadConstant","SlotToReg","RegToSlot",
       "LoadConstant","RegToSlot","FunctionCall","Label","LoadConstant",
       "LoadConstant","OperatorInstruction","RegToSlot","Label","FunctionReturn",
       "RegisterTransfer","Syscall","NilClass"]
    end

  end
end
