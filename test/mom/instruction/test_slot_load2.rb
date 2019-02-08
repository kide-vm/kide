require_relative "helper"

module Mom
  class TestSlotLoad2 < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = Risc::FakeCompiler.new
      load = SlotLoad.new( [:message, :caller, :type] , [:message, :caller , :type] )
      load.to_risc(@compiler)
      @instructions = @compiler.instructions
    end

    def test_ins_next_classes
      assert_equal Risc::SlotToReg , @instructions[0].class
      assert_equal Risc::SlotToReg , @instructions[1].class
      assert_equal Risc::SlotToReg , @instructions[2].class
    end
    def test_ins_next_next_class
      assert_equal Risc::RegToSlot , @instructions[3].class
      assert_equal NilClass , @instructions[4].class
    end

    def test_ins_next_reg
      assert_equal :r1 , @instructions[1].register.symbol
    end
    def test_ins_next_arr
      assert_equal :r1 , @instructions[1].array.symbol
    end
    def test_ins_next_index
      assert_equal 0 , @instructions[1].index
    end

    def test_ins_next_2_reg
      assert_equal :r1 , @instructions[2].register.symbol
    end
    def test_ins_next_2_arr
      assert_equal :r0 , @instructions[2].array.symbol
    end
    def test_ins_next_2_index
      assert_equal 6 , @instructions[2].index
    end

    def test_ins_next_3_reg
      assert_equal :r1 , @instructions[3].register.symbol
    end
    def test_ins_next_3_arr
      assert_equal :r1 , @instructions[3].array.symbol
    end
    def test_ins_next_3_index
      assert_equal 0 , @instructions[3].index
    end
  end
end
