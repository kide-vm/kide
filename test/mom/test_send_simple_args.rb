require_relative "helper"

module Risc
  class TestCallSimpleArgs < MiniTest::Test
    include Statements

    def setup
      super
      @input = "5.get_internal_word(1)"
      @expect = [LoadConstant, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
                 SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
                 LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
                 SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
                 RegToSlot, SlotToReg, LoadConstant, FunctionCall, Label]
    end

    def test_send_instructions
      assert_nil msg = check_nil , msg
    end
    def test_load_5
      produced = produce_body
      assert_equal 5 , produced.next(16).constant.value
    end
    def test_load_arg_const
      produced = produce_body
      assert_equal LoadConstant , produced.next(19).class
      assert_equal Mom::IntegerConstant , produced.next(19).constant.class
      assert_equal 1 , produced.next(19).constant.value
    end
    def test_load_next_m
      produced = produce_body
      assert_equal SlotToReg , produced.next(20).class
      assert_equal :r2 , produced.next(20).register.symbol
      assert_equal :r0 , produced.next(20).array.symbol
      assert_equal 2 , produced.next(20).index
    end
    def test_load_args
      produced = produce_body
      assert_equal SlotToReg , produced.next(21).class
      assert_equal :r3 , produced.next(21).register.symbol
      assert_equal :r2 , produced.next(21).array.symbol
      assert_equal 9 , produced.next(21).index
    end
    def test_store_arg_at
      produced = produce_body
      assert_equal RegToSlot , produced.next(22).class
      assert_equal :r1 , produced.next(22).register.symbol
      assert_equal :r3 , produced.next(22).array.symbol
      assert_equal  2 , produced.next(22).index , "first arg must have index 1"
    end
    def test_load_label
      produced = produce_body
      assert_equal LoadConstant , produced.next(23).class
      assert_equal Label , produced.next(23).constant.class
    end
    def test_load_some
      produced = produce_body
      assert_equal SlotToReg , produced.next(24).class
      assert_equal :r0 , produced.next(24).array.symbol
      assert_equal :r3 , produced.next(24).register.symbol
      assert_equal 2 , produced.next(24).index
    end
    def test_store_
      produced = produce_body
      assert_equal RegToSlot , produced.next(25).class
      assert_equal :r3 , produced.next(25).array.symbol
      assert_equal :r2 , produced.next(25).register.symbol
      assert_equal 5 , produced.next(25).index
    end

    def test_swap_messages
      produced = produce_body
      assert_equal SlotToReg , produced.next(26).class
      assert_equal :r0 , produced.next(26).array.symbol
      assert_equal :r0 , produced.next(26).register.symbol
      assert_equal 2 , produced.next(26).index
    end

    def test_function_call
      produced = produce_body
      assert_equal FunctionCall , produced.next(28).class
      assert_equal :get_internal_word , produced.next(28).method.name
    end
    def test_call_reg_setup
      produced = produce_body
      assert_equal produced.next(27).register , produced.next(28).register
    end
    def test_check_continue
      produced = produce_body
      assert produced.next(29).name.start_with?("continue_")
    end
    #TODO check the message setup, type and frame moves
  end
end
