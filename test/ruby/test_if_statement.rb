require_relative 'helper'

module Ruby
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
    def test_to_s
      lst = compile( double_if )
      assert_equal "if(false);  true;else;  false;end" , lst.to_s.gsub("\n",";")
    end
  end
end
