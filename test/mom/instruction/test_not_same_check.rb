require_relative "helper"

module Mom
  class TestNotSameCheck < MomInstructionTest
    def instruction
      target = SlotDefinition.new(:message , :caller)
      NotSameCheck.new(target , target , Label.new("ok" , "target"))
    end
    def test_len
      assert_equal 5 , all.length , all_str
    end
    def test_1_slot
      assert_slot_to_reg risc(1) ,:r0 , 6 , :r2
    end
    def test_2_slot
      assert_slot_to_reg risc(2) ,:r0 , 6 , :r4
    end
    def test_3_op
      assert_equal Risc::OperatorInstruction , risc(3).class
      assert_equal :r2 , risc(3).left.symbol
      assert_equal :r4 , risc(3).right.symbol
      assert_equal :- , risc(3).operator
    end
    def test_4_zero
      assert_equal Risc::IsZero , risc(4).class
      assert_label risc(4).label , "target"
    end
  end
end
