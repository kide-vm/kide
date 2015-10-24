require_relative "../helper"

module Register
  class TestInstructions < MiniTest::Test
    def setup
      @label = Label.new(nil , "test")
      @branch = Branch.new(nil , @label)
      @instruction = Instruction.new(nil)
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
