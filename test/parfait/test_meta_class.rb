require_relative "helper"

module Parfait
  class TestMetaClass < ParfaitTest

    def setup
      super
      @try = @space.create_class( :Try , :Object).meta_class
    end

    def test_type_forclass
      assert_equal "Class(Space)" ,  @space.get_type.object_class.inspect
      assert_equal :Space ,          @space.get_type.object_class.name
    end
    def test_new_superclass_name
      assert_equal :Object , @try.clazz.super_class_name
    end
    def test_new_superclass
      assert_equal "Class(Try)" , @try.clazz.inspect
      assert_equal "MetaClass(Try)" , @try.inspect
    end
    def test_new_methods
      assert_equal @try.method_names.class, @try.instance_methods.class
      assert_equal @try.method_names.get_length , @try.instance_methods.get_length
    end
    def test_remove_nothere
      assert  !@try.remove_instance_method(:foo)
    end
    def test_resolve
      assert_nil @try.resolve_method :foo
    end
    def test_remove_method
      assert_equal false , @try.remove_instance_method( :foo)
    end
    def test_add_nil_method_raises
      assert_raises{ @try.add_instance_method(nil)}
    end
    def test_add_instance_variable_changes_type
      before = @space.get_class.instance_type
      @space.get_class.add_instance_variable(:counter , :Integer)
      assert before != @space.get_class.instance_type
    end
    def test_add_instance_variable_changes_type_hash
      before = @space.get_class.instance_type.hash
      @space.get_class.add_instance_variable(:counter , :Integer)
      assert before != @space.get_class.instance_type.hash
    end

  end
end
