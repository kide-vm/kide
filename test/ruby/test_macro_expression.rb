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
      @lst = compile( "X.plus_equals(1)").to_sol
    end
    def test_class
      assert_equal Sol::MacroExpression , @lst.class
    end
    def test_arg1
      assert_equal Sol::IntegerConstant , @lst.arguments.first.class
    end
    def test_name
      assert_equal :plus_equals , @lst.name
    end
  end
  class TestPlusEqualsX < Minitest::Test
    include RubyTests
    def setup
      @lst = compile_main( "X.plus_equals(arg,1)").to_sol
    end
    def method_body
      @lst.body.first.body
    end
    def test_class
      assert_equal Sol::ClassExpression , @lst.class
      assert_equal Sol::MethodExpression , @lst.body.first.class
    end
    def test_macro_class
      assert_equal Sol::ReturnStatement , method_body.class
      assert_equal Sol::MacroExpression , method_body.return_value.class
    end
    def test_args
      assert_equal Sol::LocalVariable , method_body.return_value.arguments.first.class
      assert_equal Sol::IntegerConstant , method_body.return_value.arguments.last.class
    end
    def test_name
      assert_equal :plus_equals , method_body.return_value.name
    end
  end

end
