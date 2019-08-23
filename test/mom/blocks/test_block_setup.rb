require_relative "../helper"

module Risc
  class TestBlockSetup < MiniTest::Test
    include Statements

    def setup
      super
      @input = as_block("return 5")
      @expect = [LoadConstant, RegToSlot, LoadConstant, RegToSlot, SlotToReg, #4
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #9
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #14
                 Label,] #19
    end

    def test_send_instructions
      assert_nil msg = check_nil(:main) , msg
    end
    def test_load_5_block
      produced = produce_block.next
      assert_load( produced , Parfait::Integer)
      assert_equal 5 , produced.constant.value
    end
    def test_load_5
      produced = produce_body
      assert_load( produced , Parfait::Integer)
      assert_equal 5 , produced.constant.value
    end
    def test_load_block
      produced = produce_body.next(7)
      assert_load( produced , Parfait::Block)
      assert_equal :main_block , produced.constant.name
    end
    def test_load_return
      produced = produce_body.next(10)
      assert_load( produced , Label)
      assert produced.constant.name.start_with?("continue_")
    end
    def test_function_call
      produced = produce_body.next(14)
      assert_equal FunctionCall , produced.class
      assert_equal :main , produced.method.name
    end
    def test_check_continue
      produced = produce_body.next(15)
      assert_equal Label , produced.class
      assert produced.name.start_with?("continue_") , produced.name
    end
  end
end
