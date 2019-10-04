require_relative "helper"

module SlotLanguage
  class TestSlotMaker < MiniTest::Test
    include SlotHelper

    def test_label
      label = compile("while_label")
      assert_equal SlotMachine::Label , label.class
      assert_equal :while_label , label.name
    end
  end
end
