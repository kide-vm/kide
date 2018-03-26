require_relative "../helper"

module Parfait
  class TestBinaryCode < MiniTest::Test

    def setup
      Risc.machine.boot
      @code = BinaryCode.new(10)
    end

    def test_class
      assert_equal :BinaryCode, @code.get_type.object_class.name
    end
    def test_var_names
      assert_equal List , @code.get_instance_variables.class
    end
    def test_var_names_length
      assert_equal 2 , @code.get_instance_variables.get_length
    end
    def test_var_next
      assert_equal :next , @code.get_instance_variables[2]
    end
    def test_next_nil
      assert_nil @code.next
    end
    def test_data_length
      assert_equal 14 , @code.data_length
    end
    def test_byte_length
      assert_equal 14*4 , @code.byte_length
    end
    def test_next_not_nil
      @code = BinaryCode.new(16)
      assert @code.next
      assert_nil @code.next.next
    end
    def test_set_char1
      assert @code.set_char(1 , 1)
    end
    def test_set_char55
      assert @code.set_char(55 , 1)
    end
    def test_set_char56_raises
      assert_raises {@code.set_char(56 , 1)}
    end
    def test_set_char56_double
      @code = BinaryCode.new(16)
      assert @code.set_char(56 , 1)
    end
  end
end
