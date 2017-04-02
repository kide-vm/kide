require_relative 'helper'

module Vool
  class TestIfStatement < MiniTest::Test

    def basic_if
      "if(10 < 12) ; true ; end"
    end
    def test_if_basic
      lst = Compiler.compile( basic_if )
      assert_equal IfStatement , lst.class
    end
    def test_if_basic_cond
      lst = Compiler.compile( basic_if )
      assert_equal SendStatement , lst.condition.class
    end
    def test_if_basic_branches
      lst = Compiler.compile( basic_if )
      assert_equal TrueStatement , lst.if_true.class
      assert_nil lst.if_false
    end

    def double_if
      "if(false) ; true ; else ; false; end"
    end
    def test_if_double
      lst = Compiler.compile( double_if )
      assert_equal IfStatement , lst.class
    end
    def test_if_double_cond
      lst = Compiler.compile( double_if )
      assert_equal FalseStatement , lst.condition.class
    end
    def test_if_double_branches
      lst = Compiler.compile( double_if )
      assert_equal TrueStatement , lst.if_true.class
      assert_equal FalseStatement, lst.if_false.class
    end

    def reverse_if
      "true if(false)"
    end
    def test_if_reverse
      lst = Compiler.compile( reverse_if )
      assert_equal IfStatement , lst.class
    end
    def test_if_reverse_cond
      lst = Compiler.compile( reverse_if )
      assert_equal FalseStatement , lst.condition.class
    end
    def test_if_reverse_branches
      lst = Compiler.compile( reverse_if )
      assert_equal TrueStatement , lst.if_true.class
      assert_nil lst.if_false
    end

    def reverse_unless
      "true unless(false)"
    end
    def test_if_reverse
      lst = Compiler.compile( reverse_unless )
      assert_equal IfStatement , lst.class
    end
    def test_if_reverse_cond
      lst = Compiler.compile( reverse_unless )
      assert_equal FalseStatement , lst.condition.class
    end
    def test_if_reverse_branches
      lst = Compiler.compile( reverse_unless )
      assert_nil  lst.if_true
      assert_equal TrueStatement ,lst.if_false.class
    end

    def ternary
      "false ? true : false"
    end
    def test_if_ternary
      lst = Compiler.compile( ternary )
      assert_equal IfStatement , lst.class
    end
    def test_if_ternary_cond
      lst = Compiler.compile( ternary )
      assert_equal FalseStatement , lst.condition.class
    end
    def test_if_ternary_branches
      lst = Compiler.compile( ternary )
      assert_equal TrueStatement , lst.if_true.class
      assert_equal FalseStatement, lst.if_false.class
    end
  end
end
