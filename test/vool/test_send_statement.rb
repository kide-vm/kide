require_relative "../helper"

module Vool
  class TestSend < MiniTest::Test

    def test_simple
      lst = Compiler.compile( "foo")
      assert_equal SendStatement , lst.class
    end
    def test_simple_name
      lst = Compiler.compile( "foo")
      assert_equal :foo , lst.name
    end
    def test_simple_receiver
      lst = Compiler.compile( "foo")
      assert_equal SelfStatement , lst.receiver.class
    end
    def test_simple_args
      lst = Compiler.compile( "foo")
      assert_equal [] , lst.arguments
    end

    def test_one_arg
      lst = Compiler.compile( "bar(1)")
      assert_equal SendStatement , lst.class
    end
    def test_one_arg_name
      lst = Compiler.compile( "bar(1)")
      assert_equal :bar , lst.name
    end
    def test_one_arg_receiver
      lst = Compiler.compile( "bar(1)")
      assert_equal SelfStatement , lst.receiver.class
    end
    def test_one_arg_args
      lst = Compiler.compile( "bar(1)")
      assert_equal 1 , lst.arguments.first.value
    end

    def test_super0_receiver
      lst = Compiler.compile( "super")
      assert_equal SuperStatement , lst.receiver.class
    end
    def test_super0
      lst = Compiler.compile( "super")
      assert_equal SendStatement , lst.class
    end

    def test_super_receiver
      lst = Compiler.compile( "super(1)")
      assert_equal SuperStatement , lst.receiver.class
    end
    def test_super_args
      lst = Compiler.compile( "super(1)")
      assert_equal 1 , lst.arguments.first.value
    end
    def test_super_name #is nil
      lst = Compiler.compile( "super(1)")
      assert_nil lst.name
    end

  end
end
