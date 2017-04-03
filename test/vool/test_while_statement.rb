require_relative 'helper'

module Vool
  class TestWhileStatement < MiniTest::Test

    def basic_while
      "while(10 < 12) ; true ; end"
    end
    def test_while_basic
      lst = Compiler.compile( basic_while )
      assert_equal WhileStatement , lst.class
    end
    def test_while_basic_cond
      lst = Compiler.compile( basic_while )
      assert_equal SendStatement , lst.condition.class
    end
    def test_while_basic_branches
      lst = Compiler.compile( basic_while )
      assert_equal TrueStatement , lst.statements.class
    end

    def reverse_while
      "true while(false)"
    end
    def test_while_reverse_branches
      lst = Compiler.compile( reverse_while )
      assert_equal WhileStatement , lst.class
    end
    def test_while_reverse_cond
      lst = Compiler.compile( reverse_while )
      assert_equal FalseStatement , lst.condition.class
    end
    def test_while_reverse_branches
      lst = Compiler.compile( reverse_while )
      assert_equal TrueStatement , lst.statements.class
    end

  end
end
