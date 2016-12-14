require_relative "../helper"

class TestClass < MiniTest::Test

  def setup
    @space = Register.machine.boot.space
    @try = @space.create_class :Try , :Object
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
  def test_remove_nothere
    assert_raises RuntimeError do
       @try.remove_instance_method(:foo)
    end
  end
end
