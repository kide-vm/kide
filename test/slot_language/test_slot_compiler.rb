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
    def test_label
      label = compile("while_label")
      assert_equal SlotMachine::Label , label.class
      assert_equal :while_label , label.name
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
    def test_goto
      assert_equal SlotMachine::Jump , compile_class("goto(exit_label)")
    end
    def test_if
      check = compile("goto(exit_label) if(a == b)")
      assert_equal CheckMaker , check.class
      assert_equal SlotMachine::Jump , check.goto.class
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
      assert_equal SlotMachine::Jump , multi.last.class
    end
  end
end
