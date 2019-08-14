require_relative "helper"

module Parfait
  class TestMethods < ParfaitTest
    def setup
      super
      Mom.boot!
    end
    def test_integer
      int = Parfait.object_space.get_class_by_name :Integer
      assert_equal 13, int.instance_type.method_names.get_length
    end
    def test_methods_booted
      word = @space.get_type_by_class_name(:Word)
      assert_equal 3 , word.method_names.get_length
      assert word.get_method(:putstring) , "no putstring"
    end
  end

end
