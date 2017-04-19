require_relative "../helper"

module Vool
  class TestSend < MiniTest::Test

    def test_simple
      lst = RubyCompiler.compile( "foo")
      assert_equal SendStatement , lst.class
    end
    def test_simple_name
      lst = RubyCompiler.compile( "foo")
      assert_equal :foo , lst.name
    end
    def test_simple_receiver
      lst = RubyCompiler.compile( "foo")
      assert_equal SelfStatement , lst.receiver.class
    end
    def test_simple_args
      lst = RubyCompiler.compile( "foo")
      assert_equal [] , lst.arguments
    end

    def test_one_arg
      lst = RubyCompiler.compile( "bar(1)")
      assert_equal SendStatement , lst.class
    end
    def test_one_arg_name
      lst = RubyCompiler.compile( "bar(1)")
      assert_equal :bar , lst.name
    end
    def test_one_arg_receiver
      lst = RubyCompiler.compile( "bar(1)")
      assert_equal SelfStatement , lst.receiver.class
    end
    def test_one_arg_args
      lst = RubyCompiler.compile( "bar(1)")
      assert_equal 1 , lst.arguments.first.value
    end

    def test_super0_receiver
      lst = RubyCompiler.compile( "super")
      assert_equal SuperStatement , lst.receiver.class
    end
    def test_super0
      lst = RubyCompiler.compile( "super")
      assert_equal SendStatement , lst.class
    end

    def test_super_receiver
      lst = RubyCompiler.compile( "super(1)")
      assert_equal SuperStatement , lst.receiver.class
    end
    def test_super_args
      lst = RubyCompiler.compile( "super(1)")
      assert_equal 1 , lst.arguments.first.value
    end
    def test_super_name #is nil
      lst = RubyCompiler.compile( "super(1)")
      assert_nil lst.name
    end
  end
  class TestSendReceiverType < MiniTest::Test

    def setup
      Risc.machine.boot
    end

    def test_int_receiver
      sent = RubyCompiler.compile( "5.mod4")
      assert_equal Parfait::Type , sent.receiver.ct_type.class
      assert_equal "Integer_Type" , sent.receiver.ct_type.name
    end
    def test_string_receiver
      sent = RubyCompiler.compile( "'5'.putstring")
      assert_equal Parfait::Type , sent.receiver.ct_type.class
      assert_equal "Word_Type" , sent.receiver.ct_type.name
    end
  end
end
