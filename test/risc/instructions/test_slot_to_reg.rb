require_relative "../helper"

module Risc
  class TestSlotToReg < MiniTest::Test
    def setup
      Parfait.boot!({})
    end
    def slot
      Risc.slot_to_reg("source" , Risc.message_named_reg , :type)
    end
    def test_slot
      assert_equal SlotToReg , slot.class
    end
    def test_slot_reg
      assert_equal :"message.type" , slot.register.symbol
    end
  end
end
