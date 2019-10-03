require_relative "helper"

module Ruby
  module LastBar
    include RubyTests
    def test_last_class
      assert_equal Sol::SendStatement , @lst.last.class
    end
    def test_last_name
      assert_equal :last , @lst.last.name
    end
    def test_last_arg
      assert_equal Sol::LocalVariable , @lst.last.arguments.first.class
    end
    def test_lst_class
      assert_equal Sol::Statements , @lst.class
    end
    def test_lst_no_statements
      @lst.statements.each{|st| assert( ! st.is_a?(Sol::Statements) , st.class)}
    end
  end
  class TestSendSendArgSol < MiniTest::Test
    include LastBar
    def setup
      @lst = compile( "last(foo(1))").to_sol
    end
    def test_classes
      assert_equal Sol::Statements , @lst.class
      assert_equal Sol::LocalAssignment , @lst.first.class
      assert_equal Sol::SendStatement , @lst.last.class
    end
    def test_foo1
      assert_equal Sol::SendStatement , @lst.first.value.class
      assert_equal :foo ,  @lst.first.value.name
      assert_equal Sol::IntegerConstant , @lst.first.value.arguments.first.class
    end
  end
  class Test3SendSol < MiniTest::Test
    include LastBar
    def setup
      @lst = compile( "last(foo(more(1)))").to_sol
    end
    def test_classes
      assert_equal Sol::Statements , @lst.class
      assert_equal Sol::LocalAssignment , @lst.first.class
      assert_equal Sol::SendStatement , @lst.last.class
    end
    def test_foo
      assert_equal Sol::SendStatement , @lst.first.value.class
      assert_equal :more ,  @lst.first.value.name
      assert_equal Sol::IntegerConstant , @lst.first.value.arguments.first.class
    end
  end
  class Test5SendSol < MiniTest::Test
    include LastBar
    def setup
      @lst = compile( "last(foo(more(even_more(1),and_more(with_more))))").to_sol
    end
    def test_classes
      assert_equal Sol::Statements , @lst.class
      assert_equal Sol::LocalAssignment , @lst.first.class
      assert_equal Sol::SendStatement , @lst.last.class
    end
    def test_foo
      assert_equal Sol::SendStatement , @lst.first.value.class
      assert_equal :even_more ,  @lst.first.value.name
      assert_equal Sol::IntegerConstant , @lst.first.value.arguments.first.class
    end
  end
end
