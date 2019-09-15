require_relative "helper"

module Mom
  class TesBlockYield < MomInstructionTest
    def instruction
      BlockYield.new("source",1)
    end
    def test_len
      assert_equal 8 , all.length , all_str
    end
    def test_1_slot
      assert_slot_to_reg risc(1) ,:r0 , 1 , :r1
    end
    def test_2_load
      assert_load risc(2) , Risc::Label , :r2
      assert_label risc(2).constant , "continue_"
    end
    def test_3_reg
      assert_reg_to_slot risc(3) , :r2 , :r1 , 4
    end
    def test_4_slot
      assert_slot_to_reg risc(4) ,:r0 , 9 , :r3
    end
    def test_5_slot
      assert_slot_to_reg risc(5) ,:r0 , 1 , :r0
    end
    def test_6_jump
      assert_equal Risc::DynamicJump , risc(6).class
      assert_equal :r3 ,  risc(6).register.symbol
    end
    def test_7_label
      assert_label risc(7) , "continue_"
    end
  end
end
