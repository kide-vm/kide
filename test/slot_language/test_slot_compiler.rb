require_relative "helper"

module SlotLanguage
  class TestSlotCompiler < MiniTest::Test
    def test_init
      assert SlotCompiler.new
    end
    def test_compile
      assert_equal SlotMaker , SlotCompiler.compile("a").class
    end
    def test_fail_args
      assert_raises{  SlotCompiler.compile("a(1)")}
    end
  end
end
