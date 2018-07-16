require_relative "helper"

module Mom
  class TestSlotLoad2 < MiniTest::Test

    def setup
      Parfait.boot!
      @load = SlotLoad.new( [:message, :caller, :type] , [:message, :caller , :type] )
      @compiler = Risc::FakeCompiler.new
      @instruction = @load.to_risc(@compiler)
    end

    def test_ins_next_class
      assert_equal Risc::SlotToReg , @instruction.next(1).class
      assert_equal Risc::SlotToReg , @instruction.next(2).class
    end
    def test_ins_next_next_class
      assert_equal Risc::RegToSlot , @instruction.next(3).class
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

    def test_ins_next_2_reg
      assert_equal :r1 , @instruction.next(2).register.symbol
    end
    def test_ins_next_2_arr
      assert_equal :r0 , @instruction.next(2).array.symbol
    end
    def test_ins_next_2_index
      assert_equal 6 , @instruction.next(2).index
    end

    def test_ins_next_3_reg
      assert_equal :r1 , @instruction.next(3).register.symbol
    end
    def test_ins_next_3_arr
      assert_equal :r1 , @instruction.next(3).array.symbol
    end
    def test_ins_next_3_index
      assert_equal 0 , @instruction.next(3).index
    end
  end
end
