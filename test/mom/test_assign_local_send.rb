require_relative 'helper'

module Risc
  class TestAssignLocalSend < MiniTest::Test
    include Statements

    def setup
      super
      @input = "r = 5.mod4"
      @expect = [Label, LoadConstant, RegToSlot, Label, Label, SlotToReg ,
                 RegToSlot]
    end
    def test_local_assign_instructions
      assert_nil msg = check_nil , msg
    end

    def ttest_constant_load
      produced = produce_body
      assert_equal 5 , produced.constant.known_object.value
    end

    def ttest_slot_move
      produced = produce_body
      assert_equal produced.next.register , produced.register
    end

  end
end
