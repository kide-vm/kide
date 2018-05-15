require_relative "../helper"

module Risc
  class TestCallSimpleArgs < MiniTest::Test
    include Statements

    def setup
      super
      @input = "5.get_internal_word(1)"
      @expect = [LoadConstant, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
                 RegToSlot, SlotToReg, RegToSlot, SlotToReg, RegToSlot,
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
                 SlotToReg, LoadConstant, FunctionCall, Label]
    end

    def test_send_instructions
      assert_nil msg = check_nil , msg
    end
    def test_load_5
      produced = produce_body
      assert_equal 5 , produced.next(15).constant.value
    end
    def base
      18
    end
    def test_load_arg_const
      produced = produce_body
      assert_equal LoadConstant , produced.next(base).class
      assert_equal Parfait::Integer , produced.next(base).constant.class
      assert_equal 1 , produced.next(18).constant.value
    end
    def test_load_next_m
      produced = produce_body
      assert_equal SlotToReg , produced.next(base+1).class
      assert_equal :r2 , produced.next(base+1).register.symbol
      assert_equal :r0 , produced.next(base+1).array.symbol
      assert_equal 1 , produced.next(base+1).index
    end
    def test_load_args
      produced = produce_body
      assert_equal SlotToReg , produced.next(base+2).class
      assert_equal :r3 , produced.next(base+2).register.symbol
      assert_equal :r2 , produced.next(base+2).array.symbol
      assert_equal 8 , produced.next(base+2).index
    end
    def test_store_arg_at
      produced = produce_body
      assert_equal RegToSlot , produced.next(base+3).class
      assert_equal :r1 , produced.next(base+3).register.symbol
      assert_equal :r3 , produced.next(base+3).array.symbol
      assert_equal  1 , produced.next(base+3).index , "first arg must have index 1"
    end
    def test_load_label
      produced = produce_body
      assert_equal LoadConstant , produced.next(base+4).class
      assert_equal Label , produced.next(base+4).constant.class
    end
    def test_load_some
      produced = produce_body
      assert_equal SlotToReg , produced.next(base+5).class
      assert_equal :r0 , produced.next(base+5).array.symbol
      assert_equal :r3 , produced.next(base+5).register.symbol
      assert_equal 1 , produced.next(base+5).index
    end
    def test_store_
      produced = produce_body
      assert_equal RegToSlot , produced.next(base+6).class
      assert_equal :r3 , produced.next(base+6).array.symbol
      assert_equal :r2 , produced.next(base+6).register.symbol
      assert_equal 4 , produced.next(base+6).index
    end

    def test_swap_messages
      produced = produce_body
      assert_equal SlotToReg , produced.next(base+7).class
      assert_equal :r0 , produced.next(base+7).array.symbol
      assert_equal :r0 , produced.next(base+7).register.symbol
      assert_equal 1 , produced.next(base+7).index
    end

    def test_function_call
      produced = produce_body
      assert_equal FunctionCall , produced.next(base+9).class
      assert_equal :get_internal_word , produced.next(base+9).method.name
    end
    def test_call_reg_setup
      produced = produce_body
      assert_equal produced.next(base+8).register , produced.next(base+9).register
    end
    def test_check_continue
      produced = produce_body
      assert produced.next(base+10).name.start_with?("continue_")
    end
    #TODO check the message setup, type and frame moves
  end
end
