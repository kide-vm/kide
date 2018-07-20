require_relative 'helper'

module Ruby
  class TestIfStatementVool < MiniTest::Test
    include RubyTests

    def setup
        @lst = compile("if(true) ; a = 1 ; else ; a = 2 ; end").to_vool
    end
    def test_class
      assert_equal Vool::IfStatement , @lst.class
    end
    def test_true
      assert_equal Vool::LocalAssignment , @lst.if_true.class
    end
    def test_false
      assert_equal Vool::LocalAssignment , @lst.if_false.class
    end
    def test_condition
      assert_equal Vool::TrueConstant , @lst.condition.class
    end
  end
  class TestIfStatementVoolHoisted < MiniTest::Test
    include RubyTests

    def setup
        @lst = compile("if(a == 1) ; a = 1  end").to_vool
    end

    def test_class
      assert_equal Vool::Statements , @lst.class
    end
    def test_first_class
      assert_equal Vool::LocalAssignment , @lst.first.class
    end
    def test_last_class
      assert_equal Vool::IfStatement , @lst.last.class
    end
    def test_true
      assert_equal Vool::LocalAssignment , @lst.last.if_true.class
    end
    def test_condition
      assert_equal Vool::LocalVariable , @lst.last.condition.class
      assert_equal @lst.first.name , @lst.last.condition.name
    end
  end

end
