require_relative "helper"

module SlotLanguage
  class TestAssignment < MiniTest::Test
    include SlotHelper
    def compile_assign(str)
      assign = compile(str)
      assert_equal Assignment , assign.class
      assert_equal :a , assign.left.name
      assert_equal :b , assign.right.name
      assign
    end
    def test_slot_load_rinst
      assign = compile_assign("a = @b")
    end
    def test_slot_load_linst
      assign = compile_assign("@a = b")
    end
    def test_slot_load_lrinst
      compile_assign("@a = @b")
    end
    def test_assign
      assign = compile_assign("a = b")
      assert_equal Assignment , assign.class
    end
  end
  class TestAssignment2 < MiniTest::Test
    include SlotHelper

    def test_slot_load_linst_trav
      assert_equal Assignment , compile_class("@a = b.c")
    end
    def test_assign1
      assign = compile("c = c.next")
      assert_equal Assignment , assign.class
    end
    def test_shift
      load = compile("a = b.c")
      assert_equal Assignment , load.class
      assert_equal :a , load.left.name
      assert_equal Variable , load.right.class
    end
  end
  class TestAssignment3 < MiniTest::Test
    include SlotHelper

    def test_inst_ass
      assign = compile("@a.b = c")
      assert_equal Assignment , assign.class
      assert_equal MessageVariable , assign.left.class
      assert_equal :a , assign.left.name
      assert_equal Variable , assign.left.chain.class
      assert_equal :b , assign.left.chain.name
    end
    def test_local_ass
      assign = compile("a.b = c")
      assert_equal Assignment , assign.class
      assert_equal Variable , assign.left.class
      assert_equal :a , assign.left.name
      assert_equal Variable , assign.left.chain.class
      assert_equal :b , assign.left.chain.name
    end
  end
end
