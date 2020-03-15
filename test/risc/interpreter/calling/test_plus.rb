require_relative "../helper"

module Risc
  class InterpreterPlusTest < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.plus"
      @string_input = as_main("return 5 + 5")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, #15
                 LoadConstant, SlotToReg, OperatorInstruction, IsNotZero, SlotToReg, #20
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, SlotToReg, #25
                 OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, RegToSlot, #30
                 Branch, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #35
                 SlotToReg, FunctionReturn, SlotToReg, RegToSlot, Branch, #40
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #45
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Transfer, #50
                 Syscall, NilClass,] #55
       assert_equal 10 , get_return
    end
    def test_base
      assert_function_call 0  , :main
    end
    def test_load_receiver
      assert_slot_to_reg( 22 , :message , 2 , "message.receiver")
    end
    def test_reduce_receiver
      assert_slot_to_reg( 23 , "message.receiver" , 2 , "message.receiver.data_1" )
    end
    def test_slot_args #load args from message
      assert_slot_to_reg( 24 , :message , 9 , "message.arg1")
    end
    def test_reduce_arg
      assert_slot_to_reg( 25 , "message.arg1" , 2 , "message.arg1.data_1")
      assert_equal 5 , @interpreter.get_register(:"message.arg1.data_1")
    end
    def test_op
      assert_operator 26, :+ ,  "message.receiver.data_1" ,  "message.arg1.data_1" , "op_+_"
      assert_equal 10 , @interpreter.get_register(@instruction.result.symbol)
    end
    def test_move_res_to_int
      assert_reg_to_slot( 27 , "op_+_" , "id_factory_.next_object" , 2)
    end
    def test_move_int_to_reg
      assert_reg_to_slot( 28 , "id_factory_.next_object" , :message , 5)
    end
  end
end
