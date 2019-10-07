require_relative "helper"

module SlotLanguage
  class TestLoadMaker < MiniTest::Test
    include SlotToHelper
    def setup
      super
      left = SlotMaker.new(:hi )
      right = SlotMaker.new(:hi )
      @slot = LoadMaker.new( left,right ).to_slot(@compiler)
    end
    def test_to_slot
      assert_equal  SlotMachine::SlotLoad ,  @slot.class
    end
  end
end
