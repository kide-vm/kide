require_relative '../helper'

module Risc
  class TestAssignLocalInt < MiniTest::Test
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

    def test_frame_load
      produced = produce_body
      assert_equal :Message , produced.next(1).array.type.class_name
      assert_equal 3 , produced.next(1).index # 4 is frame
    end
    def test_value_load
      produced = produce_body
      assert_equal produced.next(2).register , produced.register
      assert_equal 1 , produced.next(2).index #type == 1 , r == 2
    end

  end
end
