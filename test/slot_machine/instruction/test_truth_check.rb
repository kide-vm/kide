require_relative "helper"

module SlotMachine
  class TestSameCheck < SlotMachineInstructionTest
    def instruction
      target = SlottedMessage.new( [:caller])
      TruthCheck.new(target , Label.new("ok" , "target"))
    end
    def test_len
      assert_equal 8 , all.length
      assert_equal Risc::Label , all.first.class
    end
    def test_1_slot
      assert_slot_to_reg risc(1) ,:message , 6 , :"message.caller"
    end
    def test_2_load
      assert_load risc(2) , Parfait::FalseClass
    end
    def test_3_op
      assert_equal Risc::OperatorInstruction , risc(3).class
      assert risc(3).left.is_object?
      assert_equal :"message.caller" , risc(3).right.symbol
      assert_equal :- , risc(3).operator
    end
    def test_4_zero
      assert_equal Risc::IsZero , risc(4).class
      assert_label risc(4).label , "target"
    end
    def test_5_load
      assert_load risc(5) , Parfait::NilClass
    end
    def test_6_op
      assert_equal Risc::OperatorInstruction , risc(6).class
      assert risc(6).left.is_object?
      assert_equal :"message.caller" , risc(6).right.symbol
      assert_equal :- , risc(6).operator
    end
    def test_7_zero
      assert_equal Risc::IsZero , risc(7).class
      assert_label risc(7).label , "target"
    end
  end
end
