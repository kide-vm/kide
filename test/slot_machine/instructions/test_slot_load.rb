require_relative "helper"

module SlotMachine
  class TestSlotLoadBasics < MiniTest::Test

    def setup
      Parfait.boot!({})
    end
    def test_ins_ok
      assert SlotLoad.new("test", [:message, :caller] , [:message , :receiver,:type] )
    end
    def test_ins_fail1
      assert_raises {SlotLoad.new( "test",[:message, :caller] , nil )}
    end
  end
end
