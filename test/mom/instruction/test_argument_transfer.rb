require_relative "helper"

module Mom
  class TestArgumentTransfer < MomInstructionTest
    def instruction
      receiver = SlotDefinition.new(:message , [:receiver])
      arg = SlotLoad.new("test", [:message, :caller] , [:message,:type] )
      ArgumentTransfer.new("" , receiver ,[arg])
    end
    def test_len
      assert_equal 6 , all.length , all_str
    end
    def test_1_slot
      assert_slot_to_reg risc(1) ,:r0 , 2 , :r2
    end
    def test_2_slot
      assert_slot_to_reg risc(2) ,:r0 , 1 , :r3
    end
    def test_3_reg
      assert_reg_to_slot risc(3) , :r2 , :r3 , 2
    end
    def test_4_slot
      assert_slot_to_reg risc(4) ,:r0 , 0 , :r2
    end
    def test_5_reg
      assert_reg_to_slot risc(5) , :r2 , :r0 , 6
    end
  end
end
