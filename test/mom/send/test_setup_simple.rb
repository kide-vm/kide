require_relative "../helper"

module Risc
  class TestMessageSetupSimple < MiniTest::Test
    include Statements

    def setup
      @preload = "Integer.div4"
      @input = "return 5.div4"
      @expect =  [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #10
                 FunctionCall, Label, SlotToReg, RegToSlot, Branch,] #15
      @produced = produce_body
    end

    def test_send_instructions
      assert_nil msg = check_nil , msg
    end
    def test_load_method
      method = @produced
      assert_load( method, Parfait::CallableMethod ,:r1)
      assert_equal :div4 , method.constant.name
    end
    def test_store_method_in_message
      sl = @produced.next( 2 )
      assert_reg_to_slot( sl , :r1  ,  :r2 ,  7 )
    end
  end
end
