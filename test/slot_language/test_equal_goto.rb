require_relative "helper"

module SlotLanguage
  class TestEqualGoto < MiniTest::Test
    include SlotHelper

    def do_check(check)
      assert_equal EqualGoto , check.class
      assert_equal Goto , check.goto.class
      assert check.left.is_a?(Variable)
      assert check.right.is_a?(Variable)
      assert_equal :a , check.left.name
      assert_equal :b , check.right.name
    end
    def test_equal_local
      check = compile("goto(exit_label) if(a == b)")
      do_check(check)
    end
    def test_equal_inst_left
      check = compile("goto(exit_label) if(@a == b)")
      do_check(check)
    end
    def test_equal_inst_right
      check = compile("goto(exit_label) if(a == @b)")
      do_check(check)
    end
  end

  class TestEqualGotoFull < MiniTest::Test
    include SlotHelper
    def setup
      @expr = compile("start_label;goto(start_label) if( b == c)")
    end
    def test_2
      assert_equal Array , @expr.class
      assert_equal 2 , @expr.length
    end
    def test_label
      assert_equal SlotMachine::Label , @expr.first.class
      assert_equal :start_label , @expr.first.name
    end
    def test_conditional
      assert_equal EqualGoto , @expr.last.class
      assert_equal :start_label , @expr.last.goto.label.name
    end
    def test_same_label
      assert_equal @expr.first.object_id , @expr.last.goto.label.object_id
    end
    def test_expression_left
      assert_equal Variable , @expr.last.left.class
      assert_equal :b , @expr.last.left.name
    end
    def test_expression_right
      assert_equal Variable , @expr.last.right.class
      assert_equal :c , @expr.last.right.name
    end
  end
  class TestEqualGotoChain < MiniTest::Test
    include SlotHelper
    def setup
      @expr = compile("goto(start_label) if( a.b == c)")
    end
    def test_eq
      assert_equal EqualGoto , @expr.class
    end
    def test_left
      assert_equal Variable , @expr.left.class
      assert_equal :a , @expr.left.name
    end
    def test_left_chain
      assert_equal Variable , @expr.left.chain.class
      assert_equal :b , @expr.left.chain.name
    end
  end
  class TestEqualGotoChain2 < MiniTest::Test
    include SlotHelper
    def setup
      @expr = compile("goto(start_label) if( a == @b.c)")
    end
    def test_eq
      assert_equal EqualGoto , @expr.class
    end
    def test_left
      assert_equal MessageVariable , @expr.right.class
      assert_equal :b , @expr.right.name
    end
    def test_left_chain
      assert_equal Variable , @expr.right.chain.class
      assert_equal :c , @expr.right.chain.name
    end
  end
end
