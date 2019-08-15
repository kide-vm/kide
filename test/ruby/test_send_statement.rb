require_relative "helper"

module Ruby
  class TestSendNoArg < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "foo")
    end
    def test_simple_class
      assert_equal SendStatement , @lst.class
    end
    def test_simple_name
      assert_equal :foo , @lst.name
    end
    def test_simple_receiver
      assert_equal SelfExpression , @lst.receiver.class
    end
    def test_simple_args
      assert_equal [] , @lst.arguments
    end
    def test_tos
      assert_equal "self.foo()" , @lst.to_s
    end
  end
  class TestSendSimpleArg < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "bar(1)")
    end
    def test_one_arg
      assert_equal SendStatement , @lst.class
    end
    def test_one_arg_name
      assert_equal :bar , @lst.name
    end
    def test_one_arg_receiver
      assert_equal SelfExpression , @lst.receiver.class
    end
    def test_one_arg_args
      assert_equal 1 , @lst.arguments.first.value
    end
  end
  class TestSendSuper < MiniTest::Test
    include RubyTests
    def test_super0_receiver
      lst = compile( "super")
      assert_equal SuperExpression , lst.receiver.class
    end
    def test_super0
      lst = compile( "super")
      assert_equal SendStatement , lst.class
    end

    def test_super_receiver
      lst = compile( "super(1)")
      assert_equal SuperExpression , lst.receiver.class
    end
    def test_super_args
      lst = compile( "super(1)")
      assert_equal 1 , lst.arguments.first.value
    end
    def test_super_name #is nil
      lst = compile( "super(1)")
      assert_nil lst.name
    end
    class TestSendSendArgs < MiniTest::Test
      include RubyTests
      def setup
        @lst = compile( "call(arg1, arg2(more))")
      end
      def test_one_arg
        assert_equal SendStatement , @lst.class
      end
      def test_one_arg_name
        assert_equal :call , @lst.name
      end
      def test_one_arg_args
        assert_equal SendStatement , @lst.arguments.first.class
      end
      def test_one_arg_args_args
        assert_equal 0 , @lst.arguments.first.arguments.length
      end
      def test_two_arg_args
        assert_equal SendStatement , @lst.arguments[1].class
      end
      def test_two_arg_args_args
        assert_equal SendStatement , @lst.arguments[1].arguments.first.class
        assert_equal :more , @lst.arguments[1].arguments.first.name
      end
    end
  end
end
