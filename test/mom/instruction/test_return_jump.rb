require_relative "helper"

module Mom
  class TestReturnJump < MomInstructionTest
    def instruction
      ReturnJump.new("source",Label.new("ok" , "return"))
    end
    def test_len
      assert_equal 2 , all.length , all_str
    end
    def test_2_branch
      assert_branch risc(1) ,"return"
    end
  end
end
