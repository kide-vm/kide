require_relative 'helper'

module Vool
  class TestIfStatement < MiniTest::Test
    include RubyTests

    def basic_if
      "if(10 < 12) ; true ; end"
    end
    def test_if_basic
      lst = compile( basic_if )
      assert_equal IfStatement , lst.class
    end
    def test_if_basic_cond
      lst = compile( basic_if )
      assert_equal ScopeStatement , lst.condition.class
    end
    def test_if_basic_branches
      lst = compile( basic_if )
      assert_equal TrueConstant , lst.if_true.class
      assert_nil lst.if_false
    end

    def double_if
      "if(false) ; true ; else ; false; end"
    end
    def test_if_double
      lst = compile( double_if )
      assert_equal IfStatement , lst.class
    end
    def test_if_double_cond
      lst = compile( double_if )
      assert_equal ScopeStatement , lst.condition.class
    end
    def test_if_double_branches
      lst = compile( double_if )
      assert_equal TrueConstant , lst.if_true.class
      assert_equal FalseConstant, lst.if_false.class
    end

    def reverse_if
      "true if(false)"
    end
    def test_if_reverse
      lst = compile( reverse_if )
      assert_equal IfStatement , lst.class
    end
    def test_if_reverse_cond
      lst = compile( reverse_if )
      assert_equal FalseConstant , lst.condition.class
    end
    def test_if_reverse_branches
      lst = compile( reverse_if )
      assert_equal TrueConstant , lst.if_true.class
      assert_nil lst.if_false
    end

    def reverse_unless
      "true unless(false)"
    end
    def test_if_reverse
      lst = compile( reverse_unless )
      assert_equal IfStatement , lst.class
    end
    def test_if_reverse_cond
      lst = compile( reverse_unless )
      assert_equal ScopeStatement , lst.condition.class
    end
    def test_if_reverse_branches
      lst = compile( reverse_unless )
      assert_nil  lst.if_true
      assert_equal TrueConstant ,lst.if_false.class
    end

    def ternary
      "false ? true : false"
    end
    def test_if_ternary
      lst = compile( ternary )
      assert_equal IfStatement , lst.class
    end
    def test_if_ternary_cond
      lst = compile( ternary )
      assert_equal FalseConstant , lst.condition.class
    end
    def test_if_ternary_branches
      lst = compile( ternary )
      assert_equal TrueConstant , lst.if_true.class
      assert_equal FalseConstant, lst.if_false.class
    end
  end
end
