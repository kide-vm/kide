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
      assert_equal Vool::Statements , @lst.class
      assert_equal 2 , @lst.length
    end
    def test_first
      assert_equal Vool::LocalAssignment , @lst.first.class
    end
    def test_last
      assert_equal Vool::SendStatement , @lst.last.class
    end
    def test_name
      assert_equal :bar , @lst.last.name
    end
    def test_receiver
      assert_equal Vool::SelfExpression , @lst.last.receiver.class
    end
    def test_args
      assert @lst.last.arguments.first.name.to_s.start_with?("tmp")
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
    def test_super_args_class
      assert_equal Vool::Statements , @lst.class
      assert_equal 2 , @lst.length
    end
    def test_super_args_first
      assert_equal Vool::LocalAssignment , @lst.first.class
    end
    def test_super_args_last
      assert_equal Vool::SendStatement , @lst.last.class
    end
    def test_super_receiver
      assert_equal Vool::SuperExpression , @lst.last.receiver.class
    end
    def test_super_name #is nil
      assert_nil @lst.last.name
    end
  end
  class TestSendReceiverTypeVool < MiniTest::Test
    include RubyTests

    def setup
      Parfait.boot!
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
