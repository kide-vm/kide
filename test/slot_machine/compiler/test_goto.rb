require_relative "../helper"

module SlotMachine
  class TestGoto < MiniTest::Test
    include SlotHelper

    def test_goto_class
      assert_equal Jump , compile_class("goto(exit_label)")
    end
    def test_goto_label
      goto = compile("goto(exit_label)")
      assert_equal Jump , goto.class
      assert_equal :exit_label , goto.label.name
    end

    def test_label
      label = compile("while_label")
      assert_equal SlotMachine::Label , label.class
      assert_equal :while_label , label.name
    end

    def test_2_label
      labels = compile("exit_label;exit_label")
      assert_equal :exit_label , labels.name
      assert_equal :exit_label , labels.next.name
      assert_equal labels.object_id , labels.next.object_id
    end

    def test_goto_with_label
      gotos = compile("exit_label;goto(exit_label)")
      assert_equal :exit_label , gotos.name
      assert_equal :exit_label , gotos.next.label.name
      assert_equal gotos.object_id , gotos.next.label.object_id
    end
  end
end
