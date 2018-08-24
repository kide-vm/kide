require_relative "../helper"

module Risc
  class TestMessageSetupSimple < MiniTest::Test
    include Statements

    def setup
      super
      @input = "5.div4"
      @expect = [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
                 RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
                 FunctionCall, Label]
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
    def test_load_space
      space = @produced.next(1)
      assert_load( space , Parfait::Space , :r2 )
    end
    def test_load_first_message #from space (ie r2)
      sl = @produced.next( 2 )
      assert_slot_to_reg( sl , :r2 ,  4 ,  :r3 )
    end
    def test_get_next_next #reduce onto itself
      sl = @produced.next( 3 )
      assert_slot_to_reg( sl , :r3 ,  1 ,  :r4 )
    end
    def test_store_next_next_in_space
      sl = @produced.next( 4 )
      assert_reg_to_slot( sl , :r4  ,  :r2 ,  4 )
    end
    def test_store_message_in_current
      sl = @produced.next( 5 )
      assert_reg_to_slot( sl , :r3  ,  :r0 ,  1 )
    end
    def test_store_caller_in_message
      sl = @produced.next( 6 )
      assert_reg_to_slot( sl , :r0  ,  :r3 ,  6 )
    end
    def test_store_method_in_message
      sl = @produced.next( 7 )
      assert_reg_to_slot( sl , :r1  ,  :r3 ,  7 )
    end
    def test_label
      sl = @produced.next( 17 )
      assert_equal Risc::Label , sl.class
      assert_equal "return_label" , sl.name
    end
  end
end
