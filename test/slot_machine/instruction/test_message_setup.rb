require_relative "helper"

module SlotMachine
  class TestMessageSetupInt < SlotMachineInstructionTest
    def instruction
      MessageSetup.new( 1 )
    end
    def test_len
      assert_equal 4 , all.length , all_str
    end
    def test_1_slot
      assert_slot_to_reg risc(1) ,:r0 , 9 , :r1
    end
    def test_2_slot
      assert_slot_to_reg risc(2) ,:r0 , 1 , :r2
    end
    def test_3_reg
      assert_reg_to_slot risc(3) , :r1 , :r2 , 7
    end
  end
  class TestMessageSetupCache < SlotMachineInstructionTest
    include Parfait::MethodHelper

    def instruction
      method = make_method
      cache_entry = Parfait::CacheEntry.new(method.frame_type, method)
      MessageSetup.new( cache_entry )
    end
    def test_len
      assert_equal 5 , all.length , all_str
    end
    def test_1_load
      assert_load risc(1) , Parfait::CacheEntry , :r1
    end
    def test_2_slot
      assert_slot_to_reg risc(2) ,:r1 , 2 , :r2
    end
    def test_3_slot
      assert_slot_to_reg risc(3) ,:r0 , 1 , :r3
    end
    def test_4_reg
      assert_reg_to_slot risc(4) , :r2 , :r3 , 7
    end

  end
end
