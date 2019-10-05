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
    # def test_fail_args
    #   assert_raises{  compile("a(1)")}
    # end
    def test_label
      label = compile("while_label")
      assert_equal SlotMachine::Label , label.class
      assert_equal :while_label , label.name
    end
    def test_slot_load
      assert_equal Sol::LocalAssignment , compile_class("a = @b")
    end
    def test_goto
      assert_equal SlotMachine::Jump , compile_class("goto(exit_label)")
    end
    def test_if
      check = compile("goto(exit_label) if(a == b)")
      assert_equal CheckMaker , check.class
      assert_equal SlotMachine::Jump , check.goto.class
    end
  end
end
