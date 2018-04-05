require_relative "../helper"

module Risc
  class TestMessageSetupSimple < MiniTest::Test
    include Statements
    include Assertions

    def setup
      super
      @input = "5.mod4"
      @expect = [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
                 SlotToReg, RegToSlot, SlotToReg, LoadConstant, FunctionCall,
                 Label]
      @produced = produce_body
    end

    def test_send_instructions
      assert_nil msg = check_nil , msg
    end
    def test_load_method
      method = @produced
      assert_load( method, Parfait::TypedMethod ,:r1)
      assert_equal :mod4 , method.constant.name
    end
    def test_load_space
      space = @produced.next(1)
      assert_load( space , Parfait::Space , :r3 )
    end
    def test_load_message
      sl = @produced.next( 2 )
      assert_slot_to_reg( sl , :r3 ,  4 ,  :r2 )
    end
    def test_load_next_message
      sl = @produced.next( 3 )
      assert_slot_to_reg( sl , :r2 ,  2 ,  :r4 )
    end
    def test_store_next_message
      sl = @produced.next( 4 )
      assert_reg_to_slot( sl , :r4  ,  :r3 ,  4 )
    end
    def test_store_current_message
      sl = @produced.next( 5 )
      assert_reg_to_slot( sl , :r2  ,  :r0 ,  2 )
    end

  end
end
