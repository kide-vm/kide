require_relative 'helper'

module Risc
  class TestAssignArgConst < MiniTest::Test
    include Statements

    def setup
      super
      @input = "arg = 5"
      @expect = [LoadConstant, RegToSlot]
    end
    def test_local_assign_instructions
      assert_nil msg = check_nil , msg
    end

    def test_constant_load
      produced = produce_body
      assert_equal 5 , produced.constant.known_object.value
    end

    def test_slot_move
      produced = produce_body
      assert_equal produced.next.register , produced.register
    end

  end
end
