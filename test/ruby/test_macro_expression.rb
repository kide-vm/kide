require_relative "helper"

module Ruby
  class TestPlusEqualsRuby < Minitest::Test
    include RubyTests
    def setup
      @lst = compile_main( "X.plus_equals(1)")
    end
    def method_body
      @lst.body.first.body
    end
    def test_class
      assert_equal Ruby::ClassStatement , @lst.class
      assert_equal Ruby::Statements , @lst.body.class
    end
    def test_method
      assert_equal Ruby::MethodStatement , @lst.body.first.class
      assert_equal Ruby::SendStatement , method_body.class
    end
    def test_send
      assert_equal :X , method_body.receiver.name
      assert_equal :plus_equals , method_body.name
    end
  end
  class TestPlusEquals < Minitest::Test
    include RubyTests
    def setup
      @lst = compile( "X.plus_equals(1)").to_vool
    end
    def test_class
      assert_equal Vool::MacroExpression , @lst.class
    end
    def test_arg1
      assert_equal Vool::IntegerConstant , @lst.arguments.first.class
    end
    def test_name
      assert_equal :plus_equals , @lst.name
    end
  end
  class TestPlusEqualsX < Minitest::Test
    include RubyTests
    def setup
      @lst = compile_main( "X.plus_equals(arg,1)").to_vool
    end
    def method_body
      @lst.body.first.body
    end
    def test_class
      assert_equal Vool::ClassExpression , @lst.class
      assert_equal Vool::MethodExpression , @lst.body.first.class
    end
    def test_macro_class
      assert_equal Vool::ReturnStatement , method_body.class
      assert_equal Vool::MacroExpression , method_body.return_value.class
    end
    def test_args
      assert_equal Vool::LocalVariable , method_body.return_value.arguments.first.class
      assert_equal Vool::IntegerConstant , method_body.return_value.arguments.last.class
    end
    def test_name
      assert_equal :plus_equals , method_body.return_value.name
    end
  end

end
