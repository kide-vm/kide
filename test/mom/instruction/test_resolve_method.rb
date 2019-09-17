require_relative "helper"

module Mom
  class TestResolveMethod < MomInstructionTest
    include Parfait::MethodHelper

    def instruction
      method = make_method
      cache_entry = Parfait::CacheEntry.new(method.frame_type, method)
      ResolveMethod.new( "method" , :name , cache_entry )
    end
    def test_len
      assert_equal 25 , all.length , all_str
    end
    def test_1_load_name
      assert_load risc(1) , Symbol , :r1
      assert_equal :name , risc(1).constant
    end
    def test_2_load_cache
      assert_load risc(2) , Parfait::CacheEntry , :r2
    end
    def test_3_get_cache_type
      assert_slot_to_reg risc(3) ,:r2 , 1 , :r3
    end
    def test_4_get_type_methods
      assert_slot_to_reg risc(4) ,:r3 , 4 , :r4
    end
    def test_5_start_label
      assert_label risc(5) , "while_start_"
    end
    def test_6_load_nil
      assert_load risc(6) , Parfait::NilClass , :r5
    end
    def test_7_check_nil
      assert_operator risc(7) , :- , :r5 , :r4
    end
    def test_8_nil_branch
      assert_zero risc(8) , "exit_label_"
    end
    def test_9_get_method_name
      assert_slot_to_reg risc(9) ,:r4 , 6 , :r6
    end
    def test_10_check_name
      assert_operator risc(10) , :- , :r6 , :r1
    end
    def test_11_nil_branch
      assert_zero risc(11) , "ok_label_"
    end
    def test_12_get_next_method
      assert_slot_to_reg risc(12) ,:r4 , 2 , :r4
    end
    def test_13_continue_while
      assert_branch risc(13) , "while_start_"
    end
    def test_14_goto_exit
      assert_label risc(14) , "exit_label_"
    end
    def test_15_load_factory
      assert_load risc(15) , Parfait::Factory , :r7
    end
    def test_16_load_next_from_factory
      assert_slot_to_reg risc(16) , :r7 ,3 ,:r8
    end
    def test_17_save_message
      assert_transfer risc(17) , :r0 , :r8
    end
    def test_18_die
      assert_syscall risc(18) , :died
    end
    def test_19_mistake1
      assert_transfer risc(19) , :r0 , :r9
    end
    def test_20_should_not_restore
      assert_transfer risc(20) , :r8 , :r0
    end
    def test_21_dead_code
      assert_slot_to_reg risc(21) , :r0 ,5 ,:r10
    end
    def test_22_dead_code
      assert_reg_to_slot risc(22) , :r9 , :r10 , 2
    end
    def test_23_label
      assert_label risc(23) , "ok_label_"
    end
    def test_24_load_method
      assert_reg_to_slot risc(24) , :r4 , :r2 , 2
    end
  end
end
