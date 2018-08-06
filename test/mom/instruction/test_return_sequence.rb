require_relative "../helper"

module Risc
  class TestReturnSequence < MiniTest::Test
    include Statements

    def setup
      super
      @input = "5.div4"
      @expect = "something"
      @produced = produce_instructions
    end
    def main_ends
      24
    end
    def test_postamble_classes
      postamble.each_with_index do |ins , index|
        assert_equal ins , @produced.next( main_ends + index).class
      end
    end
    def test_main_label
      assert_equal Label , @produced.next(main_ends).class
      assert_equal "return_label" , @produced.next(main_ends).name
    end
    def test_move_ret
      assert_slot_to_reg( @produced.next(main_ends + 1) , :r0 ,  5 ,  :r1 )
    end
    def test_move_caller
      assert_slot_to_reg( @produced.next(main_ends + 2) , :r0 ,  6 ,  :r2 )
    end
    def test_save_ret
      assert_reg_to_slot( @produced.next(main_ends + 3) , :r1  ,  :r2 ,  5 )
    end
    def test_save_addr
      assert_slot_to_reg( @produced.next(main_ends + 4) , :r0 ,  4 ,  :r1 )
    end
    def test_reduce_addr
      assert_slot_to_reg( @produced.next(main_ends + 5) , :r1 ,  2 ,  :r1 )
    end
  end
end
