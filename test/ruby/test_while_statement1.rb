require_relative 'helper'

module Ruby
  class TestWhileStatementSol < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "while(@arg) ; @arg = 1 ; end" ).to_sol
    end
    def test_class
      assert_equal Sol::WhileStatement , @lst.class
    end
    def test_body_class
      assert_equal Sol::IvarAssignment , @lst.body.class
    end
    def test_condition_class
      assert_equal Sol::InstanceVariable , @lst.condition.class
    end
    def test_no_hoist
      assert_nil @lst.hoisted
    end
  end
  class TestWhileStatementHoist < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "while(call(arg > 1)) ; arg = 1 ; end" ).to_sol
    end
    def test_class
      assert_equal Sol::WhileStatement , @lst.class
      assert_equal Sol::LocalAssignment , @lst.body.class
    end
    def test_condition_class
      assert_equal Sol::SendStatement , @lst.condition.class
    end
    def test_hoist
      assert_equal Sol::Statements , @lst.hoisted.class
    end
    def test_hoist_is_assi
      assert_equal Sol::LocalAssignment , @lst.hoisted.first.class
    end
  end
end
