require_relative "../helper"

module SlotMachine
  class TestAssignment < MiniTest::Test
    include SlotHelper
    def compile_assign(str)
      assign = compile(str)
      assert_equal SlotLoad , assign.class
      assign
    end
    def test_slot_load_rinst
      assign = compile_assign("a = @b")
      assert_equal "receiver.a" , assign.left.slots.to_s
      assert_equal "receiver.b" , assign.right.slots.to_s
    end
    def test_slot_load_linst
      assign = compile_assign("@a = b")
      assert_equal "receiver.a" , assign.left.slots.to_s
      assert_equal "b" , assign.right.slots.to_s
    end
    def test_slot_load_lrinst
      assign = compile_assign("@a = @b")
      assert_equal "receiver.a" , assign.left.slots.to_s
      assert_equal "receiver.b" , assign.right.slots.to_s
    end
    def test_assign
      assign = compile_assign("a = b")
      assert_equal "receiver.a" , assign.left.slots.to_s
      assert_equal "b" , assign.right.slots.to_s
    end
  end
  class TestAssignment2 < MiniTest::Test
    include SlotHelper

    def test_slot_load_linst_trav
      assert_equal SlotLoad , compile_class("@a = b.c")
    end
    def test_assign1
      assign = compile("c = c.next")
      assert_equal SlotLoad , assign.class
    end
    def test_shift
      load = compile("a = b.c")
      assert_equal SlotLoad , load.class
      assert_equal "receiver.a" , load.left.slots.to_s
      assert_equal "b.c" , load.right.slots.to_s
    end
  end
  class TestAssignment3 < MiniTest::Test
    include SlotHelper

    def test_inst_ass
      assign = compile("@a.b = c")
      assert_equal SlotLoad , assign.class
      assert_equal SlottedMessage , assign.left.class
      assert_equal "receiver.a.b" , assign.left.slots.to_s
    end
    def test_local_ass
      assign = compile("a.b = c")
      assert_equal SlotLoad , assign.class
      assert_equal SlottedMessage , assign.left.class
      assert_equal "a.b" , assign.left.slots.to_s
      assert_equal "c" , assign.right.slots.to_s
    end
  end
end
