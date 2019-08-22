require_relative "helper"

module Parfait
  class TestBinaryCode < ParfaitTest

    def setup
      super
      @code = BinaryCode.new(10)
    end
    def bin_length
      32
    end
    def test_class
      assert_equal :BinaryCode, @code.get_type.object_class.name
    end
    def test_mem_size
      assert_equal 32 , BinaryCode.memory_size
    end
    def test_data_size
      assert_equal 29 , BinaryCode.data_length
      assert_equal 29 , @code.data_length
    end
    def test_var_names
      assert_equal List , @code.get_instance_variables.class
    end
    def test_var_names_length
      assert_equal 2 , @code.get_instance_variables.get_length
    end
    def test_var_next
      assert_equal :next_code , @code.get_instance_variables[1]
    end
    def test_next_nil
      assert_nil @code.next_code
    end
    def test_ensure_next
      assert BinaryCode , @code.ensure_next.class
      assert @code.next_code
    end
    def test_data_length
      assert_equal bin_length - 3 , @code.data_length
    end
    def test_padded_length
      assert_equal bin_length*4 , @code.padded_length
    end
    def test_byte_length
      assert_equal (bin_length - 3)*4 , @code.byte_length
    end
    def test_total_byte_length
      @code = BinaryCode.new(bin_length)
      assert_equal (bin_length - 3)*4*2 , @code.total_byte_length
    end
    def test_next_not_nil
      @code = BinaryCode.new(bin_length)
      assert @code.next_code
      assert_nil @code.next_code.next_code
    end
    def test_set_char1
      assert @code.set_char(1 , 1)
    end
    def test_set_char51
      assert @code.set_char((bin_length - 3)*4 - 1 , 1)
    end
    def test_set_char52_raises
      assert_raises {@code.set_char((bin_length - 3)*4 , 1)}
    end
    def test_set_char56_double
      @code = BinaryCode.new(bin_length)
      assert @code.set_char((bin_length - 2)*4  , 120)
    end
    def test_nilled
      assert_equal 0 , @code.get_word(0)
      assert_equal 0 , @code.get_word(bin_length - 4)
      assert_equal 0 , @code.get_last
    end
    def test_get_set_self
      @code.set_word(bin_length - 6,1)
      assert_equal 1 , @code.get_word(bin_length - 6)
    end
    def test_get_set_next
      @code = BinaryCode.new(bin_length + 4)
      @code.set_word(bin_length + 4,1)
      assert_equal 1 , @code.get_word(bin_length + 4)
    end
    def test_extend
      @code.extend_to(bin_length + 4)
      assert @code.next_code
      assert_nil @code.next_code.next_code
    end
    def test_auto_extend #extend by seting word
      assert_nil @code.next_code
      @code.set_word(bin_length + 4 , 1)
      assert @code.next_code
    end
    def test_extend_extended
      @code.extend_to(bin_length + 4)
      @code.extend_to(bin_length * 2 - 2)
      assert @code.next_code.next_code
      assert_nil @code.next_code.next_code.next_code
    end
    def test_each_word
      len = 0
      @code.each_word(false){ len += 1}
      assert_equal bin_length - 3 , len
    end
    def test_each_word_all
      len = 0
      @code.each_word{ len += 1}
      assert_equal bin_length - 2 , len
    end
    def test_each_set
      (0...(bin_length-3)).each{|i| @code.set_word(i,i)}
      all = []
      @code.each_word(false){ |w| all << w}
      assert_equal 0 , all.first
      assert_equal bin_length-4 , all.last
      assert_nil @code.next_code
    end
    def test_set_word
      assert_equal 1 , @code.set_word(1 , 1)
    end
    def test_get_word
      @code.set_word(1 , 1)
      assert_equal 1, @code.get_word(1)
    end
    def test_get_internal_word
      @code.set_word(0 , 1)
      assert_equal 1, @code.get_internal_word(BinaryCode.type_length)
    end
    def test_set_12
      @code.set_word(bin_length-4 , bin_length-4)
      assert_equal 0 , @code.get_last
      assert_nil @code.next_code
      assert_equal bin_length-4 , @code.get_word(bin_length-4)
    end
    def test_set_last_no_extend
      @code.set_last(1)
      assert_nil @code.next_code
    end
    def test_set_last_and_get
      @code.set_last(1)
      assert_equal 1, @code.get_last
    end
    def test_has_each
      sum = 0
      @code.each_block{ sum += 1}
      assert_equal sum , 1
    end
    def test_step_13
      @code.set_word(bin_length-3,bin_length-3)
      assert @code.next_code
      assert_equal bin_length-3, @code.get_word(bin_length-3)
      assert_equal bin_length-3, @code.next_code.get_word(0)
    end
  end
end
