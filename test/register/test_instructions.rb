require_relative "../helper"

module Register
  class TestInstructions < MiniTest::Test
    def setup
      @label = Label.new(nil , "test")
      @branch = Branch.new(nil , @label)
      @instruction = Instruction.new(nil)
    end
    def test_branch_tos1
      assert @branch.to_s.include?("Branch")
      assert @branch.to_s.include?("test")
    end
    def test_branch_tos2
      branch = Branch.new(nil ,nil)
      assert branch.to_s.include?("Branch")
    end
    def test_label_tos1
      assert @label.to_s.include?("Label")
    end
    def test_label_tos2
      assert Label.new(nil,nil).to_s.include?("Label")
    end
    def test_last_empty
      assert_equal @instruction, @instruction.last
    end
    def test_last_not_empty
      @instruction.set_next @branch
      assert_equal @branch, @instruction.last
    end
    def test_append_empty
      @instruction.append @branch
      assert_equal @branch, @instruction.last
    end
    def test_insert
      @instruction.insert @branch
      assert_equal @branch, @instruction.last
    end
    def test_append_not_empty
      @instruction.append @branch
      @instruction.append @label
      assert_equal @label, @instruction.last
    end
    def test_next1
      assert_equal nil , @instruction.next
    end
    def test_next2
      @instruction.set_next @label
      assert_equal @label , @instruction.next
      assert_equal nil , @instruction.next(2)
    end
    def test_replace
      @instruction.append @branch
      @instruction.replace_next @label
      assert_equal @label, @instruction.last
      assert_equal @label, @instruction.next
      assert_equal 2 , @instruction.length , @instruction.to_ac
    end
  end
end
