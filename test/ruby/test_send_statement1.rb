require_relative "helper"

module Ruby
  class TestSendNoArgSol < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "foo").to_sol
    end
    def test_simple_class
      assert_equal Sol::SendStatement , @lst.class
    end
    def test_simple_name
      assert_equal :foo , @lst.name
    end
    def test_simple_receiver
      assert_equal Sol::SelfExpression , @lst.receiver.class
    end
    def test_simple_args
      assert_equal [] , @lst.arguments
    end
  end
  class TestSendSimpleArgSol < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "bar(1)").to_sol
    end
    def test_class
      assert_equal Sol::SendStatement , @lst.class
    end
    def test_name
      assert_equal :bar , @lst.name
    end
    def test_receiver
      assert_equal Sol::SelfExpression , @lst.receiver.class
    end
    def test_args
      assert_equal Sol::IntegerConstant ,  @lst.arguments.first.class
    end
  end
  class TestSendSuperSol < MiniTest::Test
    include RubyTests
    def test_super0
      lst = compile( "super").to_sol
      assert_equal Sol::SuperStatement , lst.class
    end
    def test_super0_receiver
      lst = compile( "super").to_sol
      assert_equal Sol::SelfExpression , lst.receiver.class
    end
  end
  class TestSendSuperArgsSol < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "super(1)").to_sol
    end
    def test_super_class
      assert_equal Sol::SuperStatement , @lst.class
    end
    def test_super_receiver
      assert_equal Sol::SelfExpression , @lst.receiver.class
    end
    def test_super_name
      assert_equal :super,  @lst.name
    end
  end
  class TestSendReceiverTypeSol < MiniTest::Test
    include RubyTests

    def setup
      Parfait.boot!(Parfait.default_test_options)
    end

    def test_int_receiver
      sent = compile( "5.div4").to_sol
      assert_equal Parfait::Type , sent.receiver.ct_type.class
      assert_equal "Integer_Type" , sent.receiver.ct_type.name
    end
    def test_string_receiver
      sent = compile( "'5'.putstring").to_sol
      assert_equal Parfait::Type , sent.receiver.ct_type.class
      assert_equal "Word_Type" , sent.receiver.ct_type.name
    end
  end
  class TestSendReceiver < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "call.once.more").to_sol
    end
    def test_class
      assert_equal Sol::Statements , @lst.class
    end
    def test_one
      assert_equal Sol::LocalAssignment , @lst.first.class
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
      assert_equal Sol::SendStatement, @lst[2].class
    end
    def test_three_name
      assert_equal :more , @lst[2].name
    end
    def test_three_self
      assert @lst[2].receiver.name.to_s.start_with?("tmp_")
    end
  end
end
