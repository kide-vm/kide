require_relative "helper"

module Risc
  class TestReturnSequence < MiniTest::Test
    include Statements

    def setup
      super
      @input = "return 5.div4"
      @expect = "something"
    end
    def instruction(num) # 15 is the main, see length in support/risc_interpreter.rb main_at
      produce_main.next( 15 + num)
    end
    def test_postamble_classes
      postamble.each_with_index do |ins , index|
        assert_equal ins , instruction( index).class , "wrong at #{index}"
      end
    end
    def test_main_label
      assert_equal Label , instruction(0).class
      assert_equal "return_label" , instruction(0).name
    end
    def test_move_ret
      assert_slot_to_reg( instruction( 1 ) , :r0 ,  5 ,  :r1 )
    end
    def test_move_caller
      assert_slot_to_reg( instruction( 2 ) , :r0 ,  6 ,  :r2 )
    end
    def test_save_ret
      assert_reg_to_slot( instruction( 3 ) , :r1  ,  :r2 ,  5 )
    end
    def test_get_next
      assert_slot_to_reg( instruction( 4 ) , :r0 ,  4 , :r3 )
    end
    def test_save_addr
      assert_slot_to_reg( instruction( 5 ) , :r3 ,  2 ,  :r3 )
    end
    def test_reduce_caller
      assert_slot_to_reg( instruction( 6 ) , :r0 ,  6 ,  :r0 )
    end
    def test_function_return
      ret = instruction(7)
      assert_equal FunctionReturn , ret.class
      assert_equal :r3 , ret.register.symbol
    end
    def test_unreachable
      assert_equal Label , instruction(8).class
      assert_equal "unreachable" , instruction(8).name
    end
  end
end
