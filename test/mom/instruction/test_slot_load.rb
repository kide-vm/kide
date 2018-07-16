require_relative "helper"

module Mom
  class TestSlotLoadBasics < MiniTest::Test

    def test_ins_ok
      assert SlotLoad.new( [:message, :caller] , [:receiver,:type] )
    end
    def test_ins_fail1
      assert_raises {SlotLoad.new( [:message, :caller] , nil )}
    end
    def test_fail_on_right
      @load = SlotLoad.new( [:message, :caller] , [:receiver,:type] )
      assert_raises {@load.to_risc(Risc::FakeCompiler.new)}
    end
    def test_fail_on_left_long
      @load = SlotLoad.new( [:message, :caller , :type] , [:receiver,:type] )
      assert_raises {@load.to_risc(Risc::FakeCompiler.new)}
    end
  end
end
