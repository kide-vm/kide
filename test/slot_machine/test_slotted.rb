require_relative "helper"

module SlotMachine
  class TestSlotted < MiniTest::Test
    def test_to_s
      assert_equal "message.caller" , SlottedMessage.new([:caller]).to_s
    end
    def test_for_mess
      assert_equal 2 , SlottedMessage.new([:caller]).slots_length
    end
    def test_for_const
      slotted = Slotted.for(StringConstant.new("hi") , nil)
      assert_equal "StringConstant" , slotted.to_s
    end
  end
end
