require_relative 'helper'

module Ruby
  class TestWhileStatementVool < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "while(@arg) ; @arg = 1 ; end" ).to_vool
    end
    def test_class
      assert_equal Vool::WhileStatement , @lst.class
    end
    def test_body_class
      assert_equal Vool::IvarAssignment , @lst.body.class
    end
    def test_condition_class
      assert_equal Vool::InstanceVariable , @lst.condition.class
    end
    def test_no_hoist
      assert_nil @lst.hoisted
    end
  end
  class TestWhileStatementHoist < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "while(call(arg > 1)) ; arg = 1 ; end" ).to_vool
    end
    def test_class
      assert_equal Vool::WhileStatement , @lst.class
      assert_equal Vool::LocalAssignment , @lst.body.class
    end
    def test_condition_class
      assert_equal Vool::SendStatement , @lst.condition.class
    end
    def test_hoist
      assert_equal Vool::Statements , @lst.hoisted.class
    end
    def test_hoist_is_assi
      assert_equal Vool::LocalAssignment , @lst.hoisted.first.class
    end
  end
end
