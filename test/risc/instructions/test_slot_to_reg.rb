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
    def test_reg_as_index
      reg = RegisterValue.new(:name , :Integer)
      Risc.slot_to_reg("source" , Risc.message_named_reg , reg)
    end
    def test_reg_as_index_fail
      reg = Risc.message_named_reg
      assert_raises {Risc.slot_to_reg("source" , reg , reg)}
    end
  end
end
