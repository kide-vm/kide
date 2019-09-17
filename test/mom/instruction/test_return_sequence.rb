require_relative "helper"

module Mom
  class TestReturnSequence < MomInstructionTest
    def instruction
      ReturnSequence.new("source")
    end
    def test_len
      assert_equal 8 , all.length , all_str
    end
    def test_1_load_return_value
      assert_slot_to_reg risc(1) ,:r0 , 5 , :r1
    end
    def test_2_load_caller
      assert_slot_to_reg risc(2) ,:r0 , 6 , :r2
    end
    def test_3_store_return_in_caller
      assert_reg_to_slot risc(3) , :r1 , :r2 , 5
    end
    def test_4_load_return_address
      assert_slot_to_reg risc(4) ,:r0 , 4 , :r3
    end
    def test_5_get_int_for_address
      assert_slot_to_reg risc(5) ,:r3 , 2 , :r3
    end
    def test_6_swap_messages
      assert_slot_to_reg risc(6) ,:r0 , 6 , :r0
    end
    def test_7_do_return
      assert_equal Risc::FunctionReturn , risc(7).class
      assert_equal :r3 , risc(7).register.symbol
    end
  end
end
