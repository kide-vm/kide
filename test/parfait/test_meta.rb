require_relative "../helper"

class TestMeta < MiniTest::Test

  def setup
    @space = Register.machine.boot.space
    @try = @space.create_class(:Try , :Object).meta
    puts @try.class
  end

  def foo_method for_class = :Try
    args = Register.new_list [ Parfait::Variable.new(:Integer , :bar )]
    ::Parfait::Method.new @space.get_class_by_name(for_class) , :foo , args
  end

  def test_meta
    assert @try
  end
  def test_meta_object
    assert @space.get_class_by_name(:Object).meta
  end

  def pest_new_methods
    assert_equal @try.method_names.class, @try.instance_methods.class
    assert_equal @try.method_names.get_length , @try.instance_methods.get_length
  end
  def pest_add_method
    foo = foo_method
    assert_equal foo , @try.add_instance_method(foo)
    assert_equal 1 , @try.instance_methods.get_length
    assert_equal ":foo" , @try.method_names.inspect
  end
  def pest_remove_method
    pest_add_method
    assert_equal true , @try.remove_instance_method(:foo)
  end
  def pest_remove_nothere
    assert_raises RuntimeError do
       @try.remove_instance_method(:foo)
    end
  end
  def pest_create_method
    @try.create_instance_method :bar, Register.new_list( [ Parfait::Variable.new(:Integer , :bar )])
    assert_equal ":bar" , @try.method_names.inspect
  end
  def pest_method_get
    pest_add_method
    assert_equal Parfait::Method , @try.get_instance_method(:foo).class
  end
  def pest_method_get_nothere
    assert_equal nil , @try.get_instance_method(:foo)
    pest_remove_method
    assert_equal nil , @try.get_instance_method(:foo)
  end
  def pest_resolve
    foo = foo_method :Object
    @space.get_class_by_name(:Object).add_instance_method(foo)
    assert_equal :foo , @try.resolve_method(:foo).name
  end
  def pest_meta
    assert @try.meta_class
  end
end
