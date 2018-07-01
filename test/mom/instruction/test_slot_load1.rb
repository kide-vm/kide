require_relative "helper"

module Mom
  class TestSlotLoad1 < MiniTest::Test

    def setup
      Parfait.boot!
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
