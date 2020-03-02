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
    def test_ins
      assert_slot_to_reg @instructions ,:message , 6 , "message.caller"
    end
    def test_ins_next
      assert_slot_to_reg @instructions.next ,"message.caller" , 0 , "message.caller.type"
    end
    def test_ins_next_2
      assert_slot_to_reg @instructions.next(2) , :message , 6 , "message.caller"
    end
    def test_ins_next_3
      assert_reg_to_slot @instructions.next(3) ,"message.caller.type"  , "message.caller" , 0
    end
  end
end
