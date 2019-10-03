require_relative "helper"

module Vool
  class TestSendArgsSendSlotMachine < MiniTest::Test
    include VoolCompile

    def setup
      @compiler = compile_main( "a = main(4.div4);return a" , "Integer.div4")
      @ins = @compiler.slot_instructions.next
    end

    def test_array
      check_array [MessageSetup, ArgumentTransfer, SimpleCall, SlotLoad, MessageSetup ,
                    ArgumentTransfer, SimpleCall, SlotLoad ,SlotLoad, ReturnJump,
                    Label, ReturnSequence , Label] , @ins
    end

    def test_one_call
      assert_equal SimpleCall, @ins.next(2).class
      assert_equal :div4 , @ins.next(2).method.name
    end
    def test_two_call
      assert_equal SimpleCall, @ins.next(6).class
      assert_equal :main, @ins.next(6).method.name
    end
  end
end
