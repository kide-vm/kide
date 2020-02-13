require_relative "helper"

module SlotLanguage
  class TestGoto < MiniTest::Test
    include SlotHelper

    def test_goto_class
      assert_equal Goto , compile_class("goto(exit_label)")
    end
    def test_goto_label
      goto = compile("goto(exit_label)")
      assert_equal SlotMachine::Label , goto.label.class
      assert_equal :exit_label , goto.label.name
    end

    def test_label
      label = compile("while_label")
      assert_equal SlotMachine::Label , label.class
      assert_equal :while_label , label.name
    end

    def test_2_label
      labels = compile("exit_label;exit_label")
      assert_equal :exit_label , labels[0].name
      assert_equal :exit_label , labels[1].name
      assert_equal labels[0].object_id , labels[1].object_id
    end

    def test_goto_with_label
      gotos = compile("exit_label;goto(exit_label)")
      assert_equal :exit_label , gotos[0].name
      assert_equal :exit_label , gotos[1].label.name
      assert_equal gotos[0].object_id , gotos[1].label.object_id
    end
  end
end
