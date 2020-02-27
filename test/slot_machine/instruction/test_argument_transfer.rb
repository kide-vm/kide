require_relative "helper"

module SlotMachine
  class TestArgumentTransfer < SlotMachineInstructionTest
    def instruction
      receiver = SlottedMessage.new( [:arg1])
      arg = SlottedMessage.new( [:receiver , :type])
      ArgumentTransfer.new("" , receiver ,[arg])
    end
    def test_len
      assert_equal 8 , all.length , all_str
    end
    def test_1_slot
      assert_slot_to_reg risc(1) ,:r0 , 9 , :r2
    end
    def test_2_slot
      assert_slot_to_reg risc(2) ,:r0 , 1 , :r3
    end
    def test_3_reg
      assert_reg_to_slot risc(3) , :r2 , :r3 , 2
    end
    def test_4_slot
      assert_slot_to_reg risc(4) ,:r0 , 2 , :r2
    end
    def test_5
      assert_slot_to_reg risc(5) ,:r2 , 0 , :r2
    end
    def test_6
      assert_slot_to_reg risc(6) ,:r0 , 1 , :r3
    end
    def test_7
      assert_reg_to_slot risc(7) , :r2 , :r3 , 9
    end
  end
end
