require_relative '../helper'

module Risc
  class TestAssignLocalConst < MiniTest::Test
    include Statements

    def setup
      super
      @input = "r = 5"
      @expect = [LoadConstant,SlotToReg, RegToSlot]
    end
    def test_local_assign_instructions
      assert_nil msg = check_nil , msg
    end

    def test_constant_load
      produced = produce_body
      assert_equal 5 , produced.constant.value
    end

    def test_slot_move
      produced = produce_body
      assert_equal produced.next(2).register , produced.register
    end

  end
end
