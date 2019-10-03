require_relative 'helper'

module Ruby
  class TestIfStatementSol < MiniTest::Test
    include RubyTests

    def setup
        @lst = compile("if(true) ; a = 1 ; else ; a = 2 ; end").to_sol
    end
    def test_class
      assert_equal Sol::IfStatement , @lst.class
    end
    def test_true
      assert_equal Sol::LocalAssignment , @lst.if_true.class
      assert @lst.has_true?
    end
    def test_false
      assert_equal Sol::LocalAssignment , @lst.if_false.class
      assert @lst.has_false?
    end
    def test_condition
      assert_equal Sol::TrueConstant , @lst.condition.class
    end
    def test_to_s
      assert_tos "if (true);a = 1;else;a = 2;end" , @lst
    end
  end
  class TestIfStatementSolHoisted < MiniTest::Test
    include RubyTests

    def setup
        @lst = compile("if(foo() == 1) ; a = 1 ; end").to_sol
    end

    def test_class
      assert_equal Sol::Statements , @lst.class
    end
    def test_first_class
      assert_equal Sol::LocalAssignment , @lst.first.class
    end
    def test_last_class
      assert_equal Sol::IfStatement , @lst.last.class
    end
    def test_true
      assert_equal Sol::LocalAssignment , @lst.last.if_true.class
    end
    def test_condition
      assert_equal Sol::SendStatement , @lst.last.condition.class
      assert_equal :== , @lst.last.condition.name
    end
  end

end
