require_relative "helper"

module Vool
  class TestSend < MiniTest::Test
    include RubyTests

    def test_simple
      lst = compile( "foo")
      assert_equal SendStatement , lst.class
    end
    def test_simple_name
      lst = compile( "foo")
      assert_equal :foo , lst.name
    end
    def test_simple_receiver
      lst = compile( "foo")
      assert_equal SelfExpression , lst.receiver.class
    end
    def test_simple_args
      lst = compile( "foo")
      assert_equal [] , lst.arguments
    end

    def test_one_arg
      lst = compile( "bar(1)")
      assert_equal SendStatement , lst.class
    end
    def test_one_arg_name
      lst = compile( "bar(1)")
      assert_equal :bar , lst.name
    end
    def test_one_arg_receiver
      lst = compile( "bar(1)")
      assert_equal SelfExpression , lst.receiver.class
    end
    def test_one_arg_args
      lst = compile( "bar(1)")
      assert_equal 1 , lst.arguments.first.value
    end

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
  end
  class TestSendReceiverType < MiniTest::Test
    include RubyTests

    def setup
      Risc.machine.boot
    end

    def test_int_receiver
      sent = compile( "5.div4")
      assert_equal Parfait::Type , sent.receiver.ct_type.class
      assert_equal "Integer_Type" , sent.receiver.ct_type.name
    end
    def test_string_receiver
      sent = compile( "'5'.putstring")
      assert_equal Parfait::Type , sent.receiver.ct_type.class
      assert_equal "Word_Type" , sent.receiver.ct_type.name
    end
  end
end
