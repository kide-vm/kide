require_relative "helper"

module Parfait
  class TestNamedLists < ParfaitTest

    def test_new
      list = NamedList.new
      assert list.get_type
    end
    def test_var_names
      list = NamedList.new
      assert_equal List , list.get_instance_variables.class
    end
    def test_var_names_length
      list = NamedList.new
      assert_equal 1 , list.get_instance_variables.get_length
    end
  end
end
