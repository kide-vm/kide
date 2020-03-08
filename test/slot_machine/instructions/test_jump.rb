require_relative "helper"

module SlotMachine
  class TestJump < SlotMachineInstructionTest
    def instruction
      Jump.new( Label.new("ok" , "target"))
    end
    def test_len
      assert_equal 2 , all.length , all_str
    end
    def test_1_slot
      assert_branch 1, "target"
    end
  end
end
