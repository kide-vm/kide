require_relative "helper"

module Risc
  class InterpreterReturn < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 5")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, RegToSlot, Branch, SlotToReg, SlotToReg, #5
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, #10
                 Transfer, SlotToReg, SlotToReg, Syscall, NilClass,] #15
      assert_equal 5 , get_return
    end

    def test_call_main
      call_ins = ticks(main_at)
      assert_equal FunctionCall , call_ins.class
      assert  :main , call_ins.method.name
    end
    def test_load_5
      load_ins = main_ticks(1)
      assert_load  load_ins , Parfait::Integer
      assert_equal 5 ,  load_ins.constant.value
    end
    def test_store_ret_val
      sl = main_ticks( 2 )
      assert_reg_to_slot( sl , :r1 , :r0 , 5)
    end
    def test_branch
      sl = main_ticks( 3 )
      assert_equal Branch , sl.class
      assert_equal "return_label" , sl.label.name
    end
    def test_load_ret
      sl = main_ticks( 4 )
      assert_slot_to_reg( sl , :r0 , 5 , :r1)
    end
    def test_load_caller
      sl = main_ticks( 5 )
      assert_slot_to_reg( sl , :r0 , 6 , :r2)
    end
    def test_load_caller_ret
      sl = main_ticks( 6 )
      assert_reg_to_slot( sl , :r1 , :r2 , 5)
    end
    def test_load_ret_add
      sl = main_ticks( 7 )
      assert_slot_to_reg( sl , :r0 , 4 , :r3)
    end
    def test_reduce_addedd
      sl = main_ticks( 8 )
      assert_slot_to_reg( sl , :r3 , 2 , :r3)
    end
    def test_load_next_message
      sl = main_ticks( 9 )
      assert_slot_to_reg( sl , :r0 , 6 , :r0)
    end
    def test_function_return
      ret = main_ticks(10)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal ::Integer , link.class
    end
    def test_transfer
      transfer = main_ticks(11)
      assert_equal Transfer ,  transfer.class
    end
  end
end
