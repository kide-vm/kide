require_relative "helper"

module SlotLanguage
  class TestAssignment < MiniTest::Test
    include SlotHelper

    def test_slot_load_rinst
      assert_equal Assignment , compile_class("a = @b")
    end
    def test_slot_load_linst
      assert_equal Assignment , compile_class("@a = b")
    end
    def test_slot_load_lrinst
      assert_equal Assignment , compile_class("@a = @b")
    end
    def test_slot_load_linst_trav
      assert_equal Assignment , compile_class("@a = b.c")
    end
    def test_slot_load_linst_trav2
       assert_equal Assignment , compile_class("@a.c = b.c")
    end
    def test_assign
      assign = compile("c = d")
      assert_equal Assignment , assign.class
    end
    def test_assign1
      assign = compile("c = c.next")
      assert_equal Assignment , assign.class
    end
    def test_assign2
      assign = compile("c.next = d")
      assert_equal Assignment  , assign.class
    end
    def test_shift
      load = compile("word = name.member")
      assert_equal Assignment , load.class
      assert_equal :word , load.left.names.first
      assert_equal SlotMaker , load.right.class
    end
  end
end
