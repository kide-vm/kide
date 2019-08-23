require_relative "../helper"

module Risc
  class TestBlockSetup < MiniTest::Test
    include Statements

    def setup
      super
      @input = as_block("return 5")
      @expect =  [LoadConstant, RegToSlot, LoadConstant, LoadConstant, SlotToReg, #4
                 SlotToReg, RegToSlot, RegToSlot, RegToSlot, RegToSlot, #9
                 SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #14
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #19
                 FunctionCall, Label] #24
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
    def test_load_next_message
      produced = produce_body.next(3)
      assert_load( produced , Parfait::Factory)
      assert_equal "Message_Type" , produced.constant.for_type.name
    end
    def test_load_block
      produced = produce_body.next(13)
      assert_load( produced , Parfait::Block)
      assert_equal :main_block , produced.constant.name
    end
    def ttest_load_return
      produced = produce_body.next(18)
      assert_load( produced , Label)
      assert produced.constant.name.start_with?("continue_")
    end
    def test_function_call
      produced = produce_body.next(20)
      assert_equal FunctionCall , produced.class
      assert_equal :main , produced.method.name
    end
    def test_check_continue
      produced = produce_body.next(22)
      assert_equal Label , produced.class
#      assert produced.name.start_with?("continue_") , produced.name
    end
  end
end
