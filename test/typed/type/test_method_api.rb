require_relative "../helper"

class TestMethodApi < MiniTest::Test

  def setup
    @space = Register.machine.boot.space
    @try = @space.create_class( :Try , :Object).instance_type
  end

  def foo_method for_class = :Try
    args = Parfait::Type.for_hash( @try , { bar: :Integer})
    ::Parfait::TypedMethod.new @space.get_class_by_name(for_class).instance_type , :foo , args
  end

  def test_new_methods
    assert_equal @try.method_names.class, @try.instance_methods.class
    assert_equal @try.method_names.get_length , @try.instance_methods.get_length
  end

  def test_add_method
    foo = foo_method
    assert_equal foo , @try.add_instance_method(foo)
    assert_equal 1 , @try.instance_methods.get_length
    assert_equal ":foo" , @try.method_names.inspect
  end
  def test_remove_method
    test_add_method
    assert_equal true , @try.remove_instance_method(:foo)
  end
  def test_remove_nothere
    assert_raises RuntimeError do
       @try.remove_instance_method(:foo)
    end
  end
  def test_create_method
    args = Parfait::Type.for_hash( @try , { bar: :Integer})
    @try.create_instance_method :bar, args
    assert_equal ":bar" , @try.method_names.inspect
  end
  def test_method_get
    test_add_method
    assert_equal Parfait::TypedMethod , @try.get_instance_method(:foo).class
  end
  def test_method_get_nothere
    assert_nil  @try.get_instance_method(:foo)
    test_remove_method
    assert_nil  @try.get_instance_method(:foo)
  end
  def test_get_instance
    foo = foo_method :Object
    type = @space.get_class_by_name(:Object).instance_type
    type.add_instance_method(foo)
    assert_equal :foo , type.get_instance_method(:foo).name
  end
end
