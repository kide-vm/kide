require_relative "helper"

module Ruby
  class TestSolCallMulti2 < MiniTest::Test
    include RubyTests

    include RubyTests
    def setup
      @lst = compile( "@foo = a.call(b)").to_sol
    end
    def test_class
      assert_equal Sol::Statements , @lst.class
    end
    def test_first_class
      assert_equal Sol::LocalAssignment , @lst[0].class
    end
    def test_first_name
      assert @lst[0].name.to_s.start_with?("tmp_")
    end
    def test_second_class
      assert_equal Sol::LocalAssignment , @lst[1].class
    end
    def test_second_name
      assert @lst[1].name.to_s.start_with?("tmp_")
    end
    def test_last_class
      assert_equal Sol::IvarAssignment , @lst[2].class
    end
    def test_second_name
      assert_equal :foo,  @lst[2].name
    end
  end
end
