require_relative "../helper"

module Register
  class TestInstructions < MiniTest::Test
    def setup
      @label = Label.new("test" , "test")
      @branch = Branch.new("test" , @label)
      @instruction = Instruction.new("test")
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
    def test_each_label1
      @instruction.set_next @label
      start = Label.new("test" , "test" , @instruction)
      count = 0
      start.each_label { |l| count += 1 }
      assert_equal 2 , count
    end
    def test_each_label2
      @instruction.set_next @branch
      start = Label.new("test" , "test" , @instruction)
      count = 0
      start.each_label { |l| count += 1 }
      assert_equal 2 , count
    end
    def test_label_is_method
      label = Label.new("test" , "Object.test")
      assert label.is_method
    end
    def test_label_is_not_method
      assert ! @label.is_method
    end
  end
end
