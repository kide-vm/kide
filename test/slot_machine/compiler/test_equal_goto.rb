require_relative "../helper"

module SlotMachine
  class TestEqualGoto < MiniTest::Test
    include SlotHelper

    def do_check(code)
      check = compile(code)
      assert_equal SameCheck , check.class
      assert_equal Label , check.false_label.class
      assert check.left.is_a?(Slotted)
      assert check.right.is_a?(Slotted)
      check
    end
    def test_equal_local
      check = do_check("goto(exit_label) if(a == b)")
      assert_equal "message.a" , check.left.to_s
      assert_equal "message.b" , check.right.to_s
    end
    def test_equal_inst_left
      check = do_check("goto(exit_label) if(@a == b)")
      assert_equal "message.receiver.a" , check.left.to_s
      assert_equal "message.b" , check.right.to_s
    end
    def test_equal_inst_right
      check = do_check("goto(exit_label) if(a == @b)")
      assert_equal "message.a" , check.left.to_s
      assert_equal "message.receiver.b" , check.right.to_s
    end
  end

  class TestEqualGotoFull < MiniTest::Test
    include SlotHelper
    def setup
      @expr = compile("start_label;goto(start_label) if( b == c)")
    end
    def test_label
      assert_equal SlotMachine::Label , @expr.class
      assert_equal :start_label , @expr.name
    end
    def test_conditional
      assert_equal SameCheck , @expr.last.class
      assert_equal :start_label , @expr.last.false_label.name
    end
    def test_same_label
      assert_equal @expr.object_id , @expr.next.false_label.object_id
    end
    def test_expression_left
      assert_equal SlottedMessage , @expr.last.left.class
      assert_equal "message.b" , @expr.last.left.to_s
    end
    def test_expression_right
      assert_equal SlottedMessage , @expr.last.right.class
      assert_equal "message.c" , @expr.last.right.to_s
    end
  end
  class TestEqualGotoChain < MiniTest::Test
    include SlotHelper
    def setup
      @expr = compile("goto(start_label) if( a.b == c)")
    end
    def test_eq
      assert_equal SameCheck , @expr.class
    end
    def test_left
      assert_equal SlottedMessage , @expr.left.class
      assert_equal "message.a.b" , @expr.left.to_s
    end
  end
  class TestEqualGotoChain2 < MiniTest::Test
    include SlotHelper
    def setup
      @expr = compile("goto(start_label) if( a == @b.c)")
    end
    def test_eq
      assert_equal SameCheck , @expr.class
    end
    def test_right
      assert_equal SlottedMessage , @expr.right.class
      assert_equal "message.receiver.b.c" , @expr.right.to_s
    end
  end
end
