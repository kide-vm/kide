require_relative "helper"

module SlotMachine
  class TestNotSameCheck < SlotMachineInstructionTest
    def instruction
      target = Slotted.for(:message , :caller)
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
      assert_operator risc(3) , :-, :r2 , :r4
    end
    def test_4_zero
      assert_zero risc(4) , "target"
    end
  end
end
