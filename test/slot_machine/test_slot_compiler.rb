require_relative "helper"

module SlotMachine
  class TestSlotCompiler < MiniTest::Test
    include SlotHelper

    def test_init
      assert SlotCompiler.new
    end
    def test_labels
      assert SlotCompiler.new.labels.empty?
    end
    def test_basic_compile
      assert_equal SlottedMessage , compile("a").class
    end
  end
end
