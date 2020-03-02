require_relative "helper"

module SlotMachine
  class TestSlotLoad1 < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
      load = SlotLoad.new("test", [:message, :caller] , [:message,:type] )
      compiler = Risc.test_compiler
      load.to_risc(compiler)
      @instructions = compiler.risc_instructions.next
    end

    def test_ins_class
      assert_equal Risc::SlotToReg , @instructions.class
    end
    def test_ins_next_class
      assert_equal Risc::RegToSlot , @instructions.next.class
    end
    def test_ins_arr
      assert_equal :message , @instructions.array.symbol
    end
    def test_ins_reg
      assert_equal :"message.type" , @instructions.register.symbol
    end
    def test_ins_index
      assert_equal 0 , @instructions.index
    end
    def test_ins_next_reg
      assert_equal :"message.type" , @instructions.next.register.symbol
    end
    def test_ins_next_arr
      assert_equal :message , @instructions.next.array.symbol
    end
    def test_ins_next_index
      assert_equal 6 , @instructions.next.index
    end
  end
end
