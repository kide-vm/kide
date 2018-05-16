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
      assert_raises {@load.to_risc(CompilerMock.new)}
    end
    def test_fail_on_left_long
      @load = SlotLoad.new( [:message, :caller , :type] , [:receiver,:type] )
      assert_raises {@load.to_risc(CompilerMock.new)}
    end
  end
  class TestSlotLoadFunction < MiniTest::Test

    def setup
      Risc.machine.boot
      @load = SlotLoad.new( [:message, :caller] , [:message,:type] )
      @compiler = CompilerMock.new
      @instruction = @load.to_risc(@compiler)
    end

    def test_ins_class
      assert_equal Risc::SlotToReg , @instruction.class
    end
    def test_ins_next_class
      assert_equal Risc::RegToSlot , @instruction.next.class
    end
    def test_ins_arr
      assert_equal :r0 , @instruction.array.symbol
    end
    def test_ins_reg
      assert_equal :r1 , @instruction.register.symbol
    end
    def test_ins_index
      assert_equal 0 , @instruction.index
    end
    def test_ins_next_reg
      assert_equal :r1 , @instruction.next.register.symbol
    end
    def test_ins_next_arr
      assert_equal :r0 , @instruction.next.array.symbol
    end
    def test_ins_next_index
      assert_equal 6 , @instruction.next.index
    end
  end
end
