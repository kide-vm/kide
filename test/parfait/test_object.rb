require_relative "helper"

module Parfait
  class TestObject < ParfaitTest

    def setup
      super
      @object = ::Parfait::Object.new
    end

    def test_empty_object_doesnt_return
      assert_nil @object.get_internal_word(3)
    end

    def test_one_set1
      assert_equal @object.get_type ,  @object.set_internal_word(0, @object.get_type)
    end

    def test_type
      assert_equal ::Parfait::Type ,  @object.get_internal_word( 0 ).class
    end
     def test_type_length
       assert_equal 1 , Object.type_length
     end
     def test_set_type
       type = @object.type
       assert @object.set_type(type)
       assert @object.type = type
     end
     def test_has_type
       assert @object.has_type?
     end
     def test_set_inst
       type = @object.type
       assert @object.set_instance_variable(:type , type)
       assert_equal type , @object.type
     end
     def test_names
       assert_equal "[:type]" , @object.instance_variables.to_s
     end
  end
end
