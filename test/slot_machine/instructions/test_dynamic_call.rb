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
      assert_load risc(1) , Parfait::CacheEntry , "id_"
    end
    def test_2_slot
      assert_slot_to_reg risc(2) , "id_" , 2 , "id_.cached_method"
    end
    def test_3_load
      assert_load risc(3) , Risc::Label , "id_"
      assert_label risc(3).constant , "continue_"
    end
    def test_4_slot
      assert_slot_to_reg risc(4) , :message , 1 , "message.next_message"
    end
    def test_5_reg
      assert_reg_to_slot risc(5) , "id_" , "message.next_message" , 4
    end
    def test_6_slot
      assert_slot_to_reg risc(6) , :message , 1 , :message
    end
    def test_7_jump
      assert_equal Risc::DynamicJump , risc(7).class
      assert_register :jump , "id_.cached_method" , risc(7).register
    end
    def test_8_label
      assert_label risc(8) , "continue_"
    end
  end
end
