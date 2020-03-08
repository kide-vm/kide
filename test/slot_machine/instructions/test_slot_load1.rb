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
    def risc(i)
      return @instructions if i == 0
      @instructions.next(i)
    end
    def test_ins_0
      assert_slot_to_reg 0 , :message , 0 , "message.type"
    end
    def test_ins_1
      assert_reg_to_slot 1 ,  "message.type" ,  :message , 6
      assert_nil risc(2)
    end
  end
end
