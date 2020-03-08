require_relative "helper"

module SlotMachine
  class TestReturnJump < SlotMachineInstructionTest
    def instruction
      ReturnJump.new("source",Label.new("ok" , "return"))
    end
    def test_len
      assert_equal 2 , all.length , all_str
    end
    def test_2_branch
      assert_branch 1,"return"
    end
  end
end
