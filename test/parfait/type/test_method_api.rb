require_relative "../helper"

module Parfait
  class TestMethodApi < ParfaitTest

    def setup
      super
      @try_class = @space.create_class( :Try )
      @try_type = @try_class.instance_type
    end

    def empty_frame
      Parfait::Type.for_hash( @try_class , { })
    end
    def foo_method( for_class = :Try)
      args = Parfait::Type.for_hash( @try_class , { bar: :Integer})
      ::Parfait::CallableMethod.new( @space.get_class_by_name(for_class).instance_type , :foo , args,empty_frame)
    end
    def add_foo_to( clazz = :Try )
      foo = foo_method( clazz )
      assert_equal foo , @space.get_class_by_name(clazz).instance_type.add_method(foo)
      foo
    end
    def object_type
      @space.get_class_by_name(:Object).instance_type
    end
    def test_new_methods
      assert_equal Parfait::List , @try_type.method_names.class
      assert_equal @try_type.method_names.get_length , @try_type.methods_length
    end
    def test_add_method
      before = @try_type.methods_length
      add_foo_to
      assert_equal 1 , @try_type.methods_length - before
      assert @try_type.method_names.inspect.include?(":foo")
    end
    def test_remove_method
      add_foo_to
      assert @try_type.remove_method(:foo)
    end
    def test_remove_not_there
      assert_raises RuntimeError do
         @try_type.remove_method(:foo)
      end
    end
    def test_create_method
      args = Parfait::Type.for_hash( @try_class , { bar: :Integer})
      @try_type.create_method :bar, args , empty_frame
      assert @try_type.method_names.inspect.include?("bar")
    end
    def test_method_get
      add_foo_to
      assert_equal Parfait::CallableMethod , @try_type.get_method(:foo).class
    end
    def test_method_get_nothere
      assert_nil  @try_type.get_method(:foo)
      test_remove_method
      assert_nil  @try_type.get_method(:foo)
    end
    def test_get_instance
      foo = foo_method :Object
      type = @space.get_class_by_name(:Object).instance_type
      type.add_method(foo)
      assert_equal :foo , type.get_method(:foo).name
    end
    def test_resolve_on_object
      add_foo_to :Object
      assert_equal :foo , object_type.resolve_method( :foo ).name
    end
    def test_resolve_super
      add_foo_to :Object
      assert_equal :foo , @try_class.instance_type.resolve_method( :foo ).name
    end
    def test_resolve_is_get
      add_foo_to
      assert_equal :foo , @try_class.instance_type.resolve_method( :foo ).name
      assert_equal :foo , @try_class.instance_type.get_method( :foo ).name
    end
    def test_resolve_fail
      assert_nil object_type.resolve_method( :foo )
    end
  end
end
