require_relative "helper"

module SlotMachine
  class TestSlotLoad2 < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
      compiler = Risc.test_compiler
      load = SlotLoad.new( "test",[:message, :caller, :type] , [:message, :caller , :type] )
      load.to_risc(compiler)
      @instructions = compiler.risc_instructions.next
    end

    def test_ins_next_classes
      assert_equal Risc::SlotToReg , @instructions.class
      assert_equal Risc::SlotToReg , @instructions.next.class
      assert_equal Risc::SlotToReg , @instructions.next(2).class
    end
    def test_ins_next_next_class
      assert_equal Risc::RegToSlot , @instructions.next(3).class
      assert_equal NilClass , @instructions.next(4).class
    end
    def test_ins_next_reg
      assert_equal :r2 , @instructions.next.register.symbol
    end
    def test_ins_next_arr
      assert_equal :r2 , @instructions.next.array.symbol
    end
    def test_ins_next_index
      assert_equal 0 , @instructions.next.index
    end
    def test_ins_next_2_reg
      assert_equal :r3 , @instructions.next(2).register.symbol
    end
    def test_ins_next_2_arr
      assert_equal :r0 , @instructions.next(2).array.symbol
    end
    def test_ins_next_2_index
      assert_equal 6 , @instructions.next(2).index
    end
    def test_ins_next_3_reg
      assert_equal :r2 , @instructions.next(3).register.symbol
    end
    def test_ins_next_3_arr
      assert_equal :r3 , @instructions.next(3).array.symbol
    end
    def test_ins_next_3_index
      assert_equal 0 , @instructions.next(3).index
    end
  end
end
