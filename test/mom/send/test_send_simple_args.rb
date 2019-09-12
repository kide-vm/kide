require_relative "../helper"

module Risc
  class TestCallSimpleArgs < MiniTest::Test
    include Statements

    def setup
      @preload = "Object.get"
      @input = "5.get_internal_word(1)"
      @expect = [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, SlotToReg, FunctionCall, Label, #15
                 SlotToReg, RegToSlot, Branch,] #20
    end

    def test_send_instructions
      assert_nil msg = check_nil , msg
    end
    def test_load_5
      produced = produce_body
      assert_equal LoadConstant , produced.next(3).class
      assert_equal 5 , produced.next(3).constant.value
    end
    def base
      6
    end
    def test_load_arg_const
      produced = produce_body
      assert_load( produced.next(base) , Parfait::Integer )
      assert_equal 1 , produced.next(base).constant.value
    end
    def test_load_next_m
      produced = produce_body.next(base+1)
      assert_slot_to_reg( produced ,:r0 ,1 , :r2 )
    end
    def test_store_arg_at
      produced = produce_body.next(base+2)
      assert_reg_to_slot( produced ,:r1 ,:r2 , 9 )
    end
    def test_load_label
      produced = produce_body.next(base+3)
      assert_load( produced , Label )
    end
    def test_load_some
      produced = produce_body.next(base+4)
      assert_slot_to_reg( produced ,:r0 ,1 , :r2 )
    end
    def test_store_
      produced = produce_body.next(base+5)
      assert_reg_to_slot( produced ,:r1 ,:r2 , 4 )
    end

    def test_swap_messages
      produced = produce_body.next(base+6)
      assert_slot_to_reg( produced ,:r0 ,1 , :r0 )
    end

    def test_function_call
      produced = produce_body
      assert_equal FunctionCall , produced.next(base+7).class
      assert_equal :get_internal_word , produced.next(base+7).method.name
    end
    def test_check_continue
      produced = produce_body
      assert produced.next(base+8).name.start_with?("continue_")
    end
  end
end
