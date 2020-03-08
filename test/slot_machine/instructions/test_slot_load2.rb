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
    def risc(i)
      return @instructions if i == 0
      @instructions.next(i)
    end
    def test_ins
      assert_slot_to_reg 0 ,:message , 6 , "message.caller"
    end
    def test_ins_next
      assert_slot_to_reg 1 ,"message.caller" , 0 , "message.caller.type"
    end
    def test_ins_next_2
      assert_slot_to_reg 2 , :message , 6 , "message.caller"
    end
    def test_ins_next_3
      assert_reg_to_slot 3 ,"message.caller.type"  , "message.caller" , 0
      assert_equal NilClass , @instructions.next(4).class
    end
  end
end
