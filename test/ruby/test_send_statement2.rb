require_relative "helper"

module Ruby
  module LastBar
    include RubyTests
    def test_last_class
      assert_equal Vool::SendStatement , @lst.last.class
    end
    def test_last_name
      assert_equal :last , @lst.last.name
    end
    def test_last_arg
      assert_equal Vool::LocalVariable , @lst.last.arguments.first.class
    end
    def test_lst_class
      assert_equal Vool::Statements , @lst.class
    end
    def test_lst_no_statements
      @lst.statements.each{|st| assert( ! st.is_a?(Vool::Statements) , st.class)}
    end
  end
  class TestSendSendArgVool < MiniTest::Test
    include LastBar
    def setup
      @lst = compile( "last(foo(1))").to_vool
    end
    def test_classes
      assert_equal Vool::Statements , @lst.class
      assert_equal Vool::LocalAssignment , @lst.first.class
      assert_equal Vool::SendStatement , @lst.last.class
    end
    def test_foo1
      assert_equal Vool::SendStatement , @lst.first.value.class
      assert_equal :foo ,  @lst.first.value.name
      assert_equal Vool::IntegerConstant , @lst.first.value.arguments.first.class
    end
  end
  class Test3SendVool < MiniTest::Test
    include LastBar
    def setup
      @lst = compile( "last(foo(more(1)))").to_vool
    end
    def test_classes
      assert_equal Vool::Statements , @lst.class
      assert_equal Vool::LocalAssignment , @lst.first.class
      assert_equal Vool::SendStatement , @lst.last.class
    end
    def test_foo
      assert_equal Vool::SendStatement , @lst.first.value.class
      assert_equal :more ,  @lst.first.value.name
      assert_equal Vool::IntegerConstant , @lst.first.value.arguments.first.class
    end
  end
  class Test5SendVool < MiniTest::Test
    include LastBar
    def setup
      @lst = compile( "last(foo(more(even_more(1),and_more(with_more))))").to_vool
    end
    def test_classes
      assert_equal Vool::Statements , @lst.class
      assert_equal Vool::LocalAssignment , @lst.first.class
      assert_equal Vool::SendStatement , @lst.last.class
    end
    def test_foo
      assert_equal Vool::SendStatement , @lst.first.value.class
      assert_equal :even_more ,  @lst.first.value.name
      assert_equal Vool::IntegerConstant , @lst.first.value.arguments.first.class
    end
  end
end
