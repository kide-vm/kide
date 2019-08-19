require_relative "helper"

module Ruby
  class TestSendNoArgVool < MiniTest::Test
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
  class TestSendSimpleArgVool < MiniTest::Test
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
    def test_super0
      lst = compile( "super").to_vool
      assert_equal Vool::Statements , lst.class
      assert_equal Vool::SendStatement , lst.last.class
    end
    def test_super0_receiver
      lst = compile( "super").to_vool
      assert_equal Vool::SuperExpression , lst.first.value.class
    end
  end
  class TestSendSuperArgsVool < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "super(1)").to_vool
    end
    def test_super_class
      assert_equal Vool::Statements , @lst.class
      assert_equal Vool::SendStatement , @lst.last.class
    end
    def test_super_receiver
      assert_equal Vool::SuperExpression , @lst.first.value.class
    end
    def test_super_name
      assert @lst.first.name.to_s.start_with?("tmp")
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
  class TestSendReceiver < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "call.once.more").to_vool
    end
    def test_class
      assert_equal Vool::Statements , @lst.class
    end
    def test_one
      assert_equal Vool::LocalAssignment , @lst.first.class
    end
    def test_one_name
      assert @lst[0].name.to_s.start_with?("tmp_")
    end
    def test_one_value
      assert_equal :call , @lst[0].value.name
    end
    def test_two_name
      assert @lst[1].name.to_s.start_with?("tmp_")
    end
    def test_two_value
      assert_equal :once , @lst[1].value.name
    end
    def test_three_class
      assert_equal Vool::SendStatement, @lst[2].class
    end
    def test_three_name
      assert_equal :more , @lst[2].name
    end
    def test_three_self
      assert @lst[2].receiver.name.to_s.start_with?("tmp_")
    end
  end
end
