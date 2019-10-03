require_relative "helper"

module Ruby
  class TestStatement < MiniTest::Test
    include RubyTests

    def test_class_name
      assert_equal "Statement" , Statement.new.class_name
    end
    def test_brother
      assert_equal Sol::Statement , Statement.new.sol_brother
    end
    def test_yield
      lst = compile( "yield")
      assert_equal Sol::YieldStatement , lst.sol_brother
    end
    def test_assign
      lst = compile( "a = 4")
      assert_equal Sol::LocalAssignment , lst.sol_brother
    end

  end
end
