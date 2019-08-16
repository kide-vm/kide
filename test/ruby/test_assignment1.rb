require_relative "helper"

module Ruby
  class TestVoolCallMulti2 < MiniTest::Test
    include RubyTests

    include RubyTests
    def setup
      @lst = compile( "@foo = a.call(b)").to_vool
    end
    def test_class
      assert_equal Vool::Statements , @lst.class
    end
    def test_first_class
      assert_equal Vool::LocalAssignment , @lst[0].class
    end
    def test_first_name
      assert @lst[0].name.to_s.start_with?("tmp_")
    end
    def test_second_class
      assert_equal Vool::LocalAssignment , @lst[1].class
    end
    def test_second_name
      assert @lst[1].name.to_s.start_with?("tmp_")
    end
    def test_last_class
      assert_equal Vool::IvarAssignment , @lst[2].class
    end
    def test_second_name
      assert_equal :foo,  @lst[2].name
    end
  end
end
