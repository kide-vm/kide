require_relative "helper"

module Mom
  class TestSlotLoad1 < MiniTest::Test

    def setup
      Parfait.boot!
      load = SlotLoad.new( [:message, :caller] , [:message,:type] )
      @compiler = Risc::FakeCompiler.new
      load.to_risc(@compiler)
      @instructions = @compiler.instructions
    end

    def test_ins_class
      assert_equal Risc::SlotToReg , @instructions[0].class
    end
    def test_ins_next_class
      assert_equal Risc::RegToSlot , @instructions[1].class
    end
    def test_ins_arr
      assert_equal :r0 , @instructions[0].array.symbol
    end
    def test_ins_reg
      assert_equal :r1 , @instructions[0].register.symbol
    end
    def test_ins_index
      assert_equal 0 , @instructions[0].index
    end
    def test_ins_next_reg
      assert_equal :r1 , @instructions[1].register.symbol
    end
    def test_ins_next_arr
      assert_equal :r0 , @instructions[1].array.symbol
    end
    def test_ins_next_index
      assert_equal 6 , @instructions[1].index
    end
  end
end
