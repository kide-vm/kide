require_relative "helper"

module SlotMachine
  class TestTruthCheck < SlotMachineInstructionTest
    def instruction
      target = SlottedMessage.new( [:caller])
      TruthCheck.new(target , Label.new("ok" , "target"))
    end
    def test_len
      assert_equal 8 , all.length
      assert_equal Risc::Label , all.first.class
    end
    def test_1_slot
      assert_slot_to_reg 1,:message , 6 , :"message.caller"
    end
    def test_2_load
      assert_load 2, Parfait::FalseClass, "id_"
    end
    def test_3_op
      assert_operator 3, :- , "id_" , "message.caller"
    end
    def test_4_zero
      assert_not_zero  4  , "target"
    end
    def test_5_load
      assert_load 5, Parfait::NilClass , "id_"
    end
    def test_6_op
      assert_operator 6, :- , "id_", "message.caller"
    end
    def test_7_zero
      assert_not_zero 7 , "target"
    end
  end
end
