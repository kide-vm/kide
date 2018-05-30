require_relative "helper"

module Parfait
  class TestClass < ParfaitTest

    def test_data_class_api_base
      assert_raises {DataObject.type_length}
    end
    def test_data_class_api4
      assert_equal 4 , Data4.memory_size
    end
    def test_data_class_api8
      assert_equal 8 , Data8.memory_size
    end
    def test_data_class_api16
      assert_equal 16 , Data16.memory_size
    end
    def test_data_class_api32
      assert_equal 32 , Data32.memory_size
    end
    def test_int_len
      assert_equal 4 , Integer.new(1).data_length
    end
    def test_true_len
      assert_equal 4 , TrueClass.new.data_length
    end
    def test_false_len
      assert_equal 4 , FalseClass.new.data_length
    end
    def test_nil_len
      assert_equal 4 , NilClass.new.data_length
    end
    def test_int_pad
      assert_equal 16 , Integer.new(2).padded_length
    end
    def test_true_pad
      assert_equal 16 , TrueClass.new.padded_length
    end
    def test_false_pad
      assert_equal 16 , FalseClass.new.padded_length
    end
    def test_nil_pad
      assert_equal 16 , NilClass.new.padded_length
    end
  end
end
