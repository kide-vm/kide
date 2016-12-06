require_relative "../helper"

class TestMeta < MiniTest::Test

  def setup
    @space = Register.machine.boot.space
    @try = @space.create_class(:Try , :Object).meta
  end

  def foo_method for_class = :Try
    args = Parfait.new_list [ Parfait::Variable.new(:Integer , :bar )]
    ::Parfait::Method.new @space.get_class_by_name(for_class) , :foo , args
  end

  def test_meta
    assert @try
  end
  def test_meta_object
    assert @space.get_class_by_name(:Object).meta
  end

  def test_new_methods
    assert_equal 0 , @try.method_names.get_length
  end

  def test_create_method
      @try.create_instance_method :bar, Parfait.new_list( [ Parfait::Variable.new(:Integer , :bar )])
      assert_equal ":bar" , @try.method_names.inspect
    end
  def test_add_method
    foo = foo_method
    assert_equal foo , @try.add_instance_method(foo)
    assert_equal 1 , @try.method_names.get_length
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
  def test_method_get
    test_add_method
    assert_equal Parfait::Method , @try.get_instance_method(:foo).class
  end
  def test_method_get_nothere
    assert_nil  @try.get_instance_method(:foo)
    test_remove_method
    assert_nil  @try.get_instance_method(:foo)
  end
end
