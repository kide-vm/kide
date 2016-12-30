require_relative "../helper"

class TestMethodApi < MiniTest::Test

  def setup
    @space = Register.machine.boot.space
    @try_class = @space.create_class( :Try )
    @try_type = @try_class.instance_type
  end

  def foo_method for_class = :Try
    args = Parfait::Type.for_hash( @try_class , { bar: :Integer})
    ::Parfait::TypedMethod.new @space.get_class_by_name(for_class).instance_type , :foo , args
  end

  def test_new_methods
    assert_equal @try_type.method_names.class, @try_type.methods.class
    assert_equal @try_type.method_names.get_length , @try_type.methods.get_length
  end

  def test_add_method
    before = @try_type.methods.get_length
    foo = foo_method
    assert_equal foo , @try_type.add_method(foo)
    assert_equal 1 , @try_type.methods.get_length - before
    assert @try_type.method_names.inspect.include?(":foo")
  end
  def test_remove_method
    test_add_method
    assert_equal true , @try_type.remove_method(:foo)
  end
  def test_remove_nothere
    assert_raises RuntimeError do
       @try_type.remove_method(:foo)
    end
  end
  def test_create_method
    args = Parfait::Type.for_hash( @try_class , { bar: :Integer})
    @try_type.create_method :bar, args
    assert @try_type.method_names.inspect.include?("bar")
  end
  def test_method_get
    test_add_method
    assert_equal Parfait::TypedMethod , @try_type.get_method(:foo).class
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
end
