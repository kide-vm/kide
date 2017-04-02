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

    def test_if_double
      lst = Compiler.compile( "if(false) ; true ; else ; false; end" )
      assert_equal IfStatement , lst.class
    end

  end
end
