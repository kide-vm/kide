require_relative "helper"

module SlotLanguage
  class TestSlotCompiler < MiniTest::Test
    include SlotHelper

    def test_init
      assert SlotCompiler.new
    end
    def test_labels
      assert SlotCompiler.new.labels.empty?
    end
    def test_compile
      assert_equal SlotMaker , compile("a").class
    end
  end
end
