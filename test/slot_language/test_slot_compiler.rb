require_relative "helper"

module SlotLanguage
  class TestSlotCompiler < MiniTest::Test
    include SlotHelper

    def test_init
      assert SlotCompiler.new
    end
    def test_compile
      assert_equal SlotMaker , compile("a").class
    end
    def test_slot_load_rinst
      assert_equal LoadMaker , compile_class("a = @b")
    end
    def test_slot_load_linst
      assert_equal LoadMaker , compile_class("@a = b")
    end
    def test_slot_load_lrinst
      assert_equal LoadMaker , compile_class("@a = @b")
    end
    def test_slot_load_linst_trav
      assert_equal LoadMaker , compile_class("@a = b.c")
    end
    def test_slot_load_linst_trav2
       assert_equal LoadMaker , compile_class("@a.c = b.c")
    end
    def test_if
      check = compile("goto(exit_label) if(a == b)")
      assert_equal CheckMaker , check.class
      assert_equal Goto , check.goto.class
    end
    def test_assign
      assign = compile("c = d")
      assert_equal LoadMaker , assign.class
    end
    def test_assign1
      assign = compile("c = c.next")
      assert_equal LoadMaker , assign.class
    end
    def test_assign2
      assign = compile("c.next = d")
      assert_equal LoadMaker  , assign.class
    end
    def test_multiline
      multi = compile("start_label;c = c.next;goto(start_label)")
      assert_equal Array , multi.class
      assert_equal SlotMachine::Label , multi.first.class
      assert_equal Goto , multi.last.class
    end
    def test_shift
      load = compile("word = name.member")
      assert_equal LoadMaker , load.class
      assert_equal :word , load.left.names.first
      assert_equal SlotMaker , load.right.class
    end
  end
end
