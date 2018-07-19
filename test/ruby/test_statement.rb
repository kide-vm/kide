require_relative "helper"

module Ruby
  class TestStatement < MiniTest::Test
    include RubyTests

    def test_class_name
      assert_equal "Statement" , Statement.new.class_name
    end
    def test_brother
      assert_equal Vool::Statement , Statement.new.vool_brother
    end
    def test_yield
      lst = compile( "yield")
      assert_equal Vool::YieldStatement , lst.vool_brother
    end
    def test_assign
      lst = compile( "a = 4")
      assert_equal Vool::LocalAssignment , lst.vool_brother
    end

  end
end
