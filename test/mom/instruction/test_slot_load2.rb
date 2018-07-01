require_relative "helper"

module Mom
  class TestSlotLoad2 < MiniTest::Test

    def setup
      Parfait.boot!
      Risc.boot!
      @load = SlotLoad.new( [:message, :caller] , [:message, :caller , :type] )
      @compiler = CompilerMock.new
      @instruction = @load.to_risc(@compiler)
    end

    def test_ins_next_class
      assert_equal Risc::SlotToReg , @instruction.next.class
    end
    def test_ins_next_next_class
      assert_equal Risc::RegToSlot , @instruction.next.next.class
    end

    def test_ins_next_reg
      assert_equal :r1 , @instruction.next.register.symbol
    end
    def test_ins_next_arr
      assert_equal :r1 , @instruction.next.array.symbol
    end
    def test_ins_next_index
      assert_equal 0 , @instruction.next.index
    end

    def test_ins_next_next_reg
      assert_equal :r1 , @instruction.next.next.register.symbol
    end
    def test_ins_next_next_arr
      assert_equal :r0 , @instruction.next.next.array.symbol
    end
    def test_ins_next_next_index
      assert_equal 6 , @instruction.next.next.index
    end
  end
end
