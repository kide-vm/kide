require_relative "helper"

module Ruby
  class TestSendFooVool < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "foo").to_vool
    end
    def test_simple_class
      assert_equal Vool::SendStatement , @lst.class
    end
    def test_simple_name
      assert_equal :foo , @lst.name
    end
    def test_simple_receiver
      assert_equal Vool::SelfExpression , @lst.receiver.class
    end
    def test_simple_args
      assert_equal [] , @lst.arguments
    end
  end
  class TestSendBarVool < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "bar(1)").to_vool
    end
    def test_class
      assert_equal Vool::SendStatement , @lst.class
    end
    def test_name
      assert_equal :bar , @lst.name
    end
    def test_receiver
      assert_equal Vool::SelfExpression , @lst.receiver.class
    end
    def test_args
      assert_equal Vool::IntegerConstant ,  @lst.arguments.first.class
    end
  end
  class TestSendSuperVool < MiniTest::Test
    include RubyTests
    def test_super0_receiver
      lst = compile( "super").to_vool
      assert_equal Vool::SuperExpression , lst.receiver.class
    end
    def test_super0
      lst = compile( "super").to_vool
      assert_equal Vool::SendStatement , lst.class
    end
  end
  class TestSendSuperArgsVool < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "super(1)").to_vool
    end
    def test_super_class
      assert_equal Vool::SendStatement , @lst.class
    end
    def test_super_receiver
      assert_equal Vool::SuperExpression , @lst.receiver.class
    end
    def test_super_name #is nil
      assert_nil @lst.name
    end
  end
  class TestSendReceiverTypeVool < MiniTest::Test
    include RubyTests

    def setup
      Parfait.boot!(Parfait.default_test_options)
    end

    def test_int_receiver
      sent = compile( "5.div4").to_vool
      assert_equal Parfait::Type , sent.receiver.ct_type.class
      assert_equal "Integer_Type" , sent.receiver.ct_type.name
    end
    def test_string_receiver
      sent = compile( "'5'.putstring").to_vool
      assert_equal Parfait::Type , sent.receiver.ct_type.class
      assert_equal "Word_Type" , sent.receiver.ct_type.name
    end
  end
end
