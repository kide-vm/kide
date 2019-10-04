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
      compile("a = @b")
    end
  end
end
