require_relative "helper"

module SlotMachine
  class TestResolveMethod < SlotMachineInstructionTest
    include Parfait::MethodHelper

    def instruction
      method = make_method
      cache_entry = Parfait::CacheEntry.new(method.frame_type, method)
      ResolveMethod.new( "method" , :name , cache_entry )
    end
    def test_len
      assert_equal 21 , all.length , all_str
    end
    def test_load_name
      assert_load 1, Parfait::Word , "id_word_"
      assert_equal "name" , risc(1).constant.to_string
    end
    def test_load_cache
      assert_load 2, Parfait::CacheEntry , "id_cacheentry_"
    end
    def test_get_cache_type
      assert_slot_to_reg 3 , "id_cacheentry_" , 1 , "id_cacheentry_.cached_type"
    end
    def test_get_type_methods
      assert_slot_to_reg 4 , "id_cacheentry_.cached_type" , 4 , "id_cacheentry_.cached_type.methods"
    end
    def test_start_label
      assert_label 5 , "while_start_"
    end
    def test_load_nil
      assert_load 6, Parfait::NilClass , "id_nilclass_"
    end
    def test_check_nil
      assert_operator 7, :- , "id_nilclass_" , "id_cacheentry_.cached_type.methods" , "op_-_"
    end
    def test_nil_branch
      assert_zero 8, "exit_label_"
    end
    def test_get_method_name
      assert_slot_to_reg 9, "id_cacheentry_.cached_type.methods" , 6 , "id_cacheentry_.cached_type.methods.name"
    end
    def test_check_name
      assert_operator 10, :- , "id_cacheentry_.cached_type.methods.name" , "id_word_" , "op_-_"
    end
    def test_nil_branch
      assert_zero 11, "ok_label_"
    end
    def test_get_next_method
      assert_slot_to_reg 12, "id_cacheentry_.cached_type.methods" , 2 , "id_cacheentry_.cached_type.methods.next_callable"
    end
    def test_trans
      assert_transfer 13 , "id_cacheentry_.cached_type.methods.next" , "id_cacheentry_.cached_type.methods"
    end
    def test_continue_while
      assert_branch 14, "while_start_"
    end
    def test_goto_exit
      assert_label 15, "exit_label_"
    end
    def test_load_name2
      assert_load 16, Parfait::Word , "id_word_"
      assert_equal "name" , risc(1).constant.to_string
    end
    def test_move_name
      assert_transfer 17, "id_word_" , :r1
    end
    def test_sys
      assert_syscall 18, :died
    end
    def test_label
      assert_label 19, "ok_label_"
    end
    def test_method
      assert_reg_to_slot 20 , "id_cacheentry_.cached_type.methods" , "id_cacheentry_" , 2
    end
  end
end
