require_relative "helper"

module SlotLanguage
  class TestVariable < MiniTest::Test
    include SlotHelper
    def test_basic_compile
      assert_equal Variable , compile("a").class
    end
  end
end
