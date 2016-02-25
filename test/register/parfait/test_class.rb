require_relative "../helper"

class TestClass < MiniTest::Test

  def setup
    @space = Register.machine.boot.space
    @try = @space.create_class :Try , :Object
  end

  def foo_method for_class = :Try
    args = Parfait.new_list [ Parfait::Variable.new(:Integer , :bar )]
    ::Parfait::Method.new @space.get_class_by_name(for_class) , :foo , args
  end

  def test_type_forclass
    assert_equal "Class(Space)" ,  @space.get_type.object_class.inspect
    assert_equal :Space ,          @space.get_type.object_class.name
  end
  def test_new_superclass_name
    assert_equal :Object , @try.super_class_name
  end
  def test_new_superclass
    assert_equal "Class(Object)" , @try.super_class.inspect
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
    @try.create_instance_method :bar, Parfait.new_list( [ Parfait::Variable.new(:Integer , :bar )])
    assert_equal ":bar" , @try.method_names.inspect
  end
  def test_method_get
    test_add_method
    assert_equal Parfait::Method , @try.get_instance_method(:foo).class
  end
  def test_method_get_nothere
    assert_equal nil , @try.get_instance_method(:foo)
    test_remove_method
    assert_equal nil , @try.get_instance_method(:foo)
  end
  def test_resolve
    foo = foo_method :Object
    @space.get_class_by_name(:Object).add_instance_method(foo)
    assert_equal :foo , @try.resolve_method(:foo).name
  end
end
