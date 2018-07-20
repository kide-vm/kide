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
      @lst = compile( "while(arg > 1) ; arg = 1 ; end" ).to_vool
    end
    def test_class
      assert_equal Vool::WhileStatement , @lst.class
      assert_equal Vool::LocalAssignment , @lst.body.class
    end
    def test_condition_class
      assert_equal Vool::LocalVariable , @lst.condition.class
    end
    def test_hoist
      assert_equal Vool::LocalAssignment , @lst.hoisted.class
    end
    def test_hoist_is_cond
      assert_equal @lst.hoisted.name , @lst.condition.name
    end
  end
end
