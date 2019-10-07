require_relative "helper"

module SlotLanguage
  class TestSlotMaker < MiniTest::Test
    include SlotToHelper
    def setup
      super
      @maker = SlotMaker.new(:hi )
    end
    def test_slot
      @maker.slot_def(@compiler)
    end
  end
end
