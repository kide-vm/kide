require_relative "helper"

module SlotMachine
  class TestDynamicCall < SlotMachineInstructionTest
    def instruction
      DynamicCall.new(nil,nil)
    end
    def test_len
      assert_equal 9 , all.length , all_str
    end
    def test_1_load
      assert_load risc(1) , Risc::Label , :r1
      assert_label risc(1).constant , "continue_" 
    end
    def test_2_slot
      assert_slot_to_reg risc(2) ,:r0 , 1 , :r2
    end
    def test_3_reg
      assert_reg_to_slot risc(3) , :r1 , :r2 , 4
    end
    def test_4_slot
      assert_slot_to_reg risc(4) ,:r0 , 1 , :r0
    end
    def test_5_load
      assert_load risc(5) , Parfait::CacheEntry , :r3
    end
    def test_6_slot
      assert_slot_to_reg risc(6) ,:r3 , 2 , :r3
    end
    def test_7_jump
      assert_equal Risc::DynamicJump , risc(7).class
    end
    def test_8_label
      assert_label risc(8) , "continue_"
    end
  end
end
