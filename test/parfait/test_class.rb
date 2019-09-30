require_relative "helper"

module Parfait
  class TestClass < ParfaitTest

    def setup
      super
      @try = @space.create_class :Try , :Object
    end

    def test_type_forclass
      assert_equal "Class(Space)" ,  @space.get_type.object_class.inspect
      assert_equal :Space ,          @space.get_type.object_class.name
    end
    def test_new_superclass_name
      assert_equal :Object , @try.super_class_name
    end
    def test_existing_superclass_name
      assert_equal :Object , @space.classes[:Type].super_class_name
    end
    def test_new_superclass
      assert_equal "Class(Object)" , @try.super_class!.inspect
      assert_equal "Class(Object)" , @try.super_class.inspect
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
    def test_has_single
      assert_equal SingletonClass , @try.single_class.class
    end
    def test_before_not_single_type
      assert_equal false , @try.type.is_single?
    end
    def test_single_type_not_class
      hash_after = @try.single_class.instance_type.hash
      assert_equal @try.type.hash , hash_after
    end
    def test_single_type_not_class_before
      hash_before = @try.type.hash
      hash_after = @try.single_class.instance_type.hash
      refute_equal hash_before , hash_after
    end
  end
end
