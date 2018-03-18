require_relative "../helper"

class TestMethod < MiniTest::Test

  def setup
    obj = Parfait.object_space.get_class_by_name(:Object).instance_type
    args = Parfait::Type.for_hash( obj.object_class , { bar: :Integer , foo: :Type})
    frame = Parfait::Type.for_hash( obj.object_class , { local_bar: :Integer , local_foo: :Type})
    @method = Parfait::TypedMethod.new( obj , :meth , args , frame)
  end

  def test_method_name
    assert_equal :meth , @method.name
  end

  def test_class_for
    assert_equal :Object , @method.for_type.object_class.name
  end

  def test_arg1
    assert_equal 2 , @method.arguments_length , @method.arguments.inspect
    assert_equal Symbol , @method.arguments.names.first.class
    assert_equal :bar , @method.argument_name(1)
  end

  def test_has_argument
    assert_equal 1 , @method.has_argument(:bar)
    assert_equal 2 , @method.has_argument(:foo)
  end

  def test_add_arg
    @method.add_argument(:foo2 , :Object)
    assert_equal 3 , @method.arguments_length
    assert_equal :foo2 , @method.argument_name(3)
    assert_equal :Object , @method.arguments_type(3)
  end

  def test_get_arg_name1
    index = @method.has_argument(:bar)
    assert_equal 1 , index
    assert_equal :bar , @method.argument_name(index)
  end
  def test_get_arg_type1
    index = @method.has_argument(:bar)
    assert_equal :Integer , @method.arguments_type(index)
  end
  def test_get_arg_name2
    index = @method.has_argument(:foo)
    assert_equal 2 , index
    assert_equal :foo , @method.argument_name(index)
  end
  def test_get_arg_type2
    index = @method.has_argument(:foo)
    assert_equal :Type , @method.arguments_type(index)
  end

  def test_local1
    assert_equal 2 , @method.frame_length , @method.frame.inspect
    assert_equal Symbol , @method.frame.names.first.class
    assert_equal :local_bar , @method.locals_name(1)
  end

  def test_has_local
    assert_equal 1 , @method.has_local(:local_bar)
    assert_equal 2 , @method.has_local(:local_foo)
  end

  def test_add_local
    @method.add_local(:foo2 , :Object)
    assert_equal 3 , @method.frame_length
    assert_equal :foo2 , @method.locals_name(3)
    assert_equal :Object , @method.frame_type(3)
  end

  def test_get_locals_name1
    index = @method.has_local(:local_bar)
    assert_equal 1 , index
    assert_equal :local_bar , @method.locals_name(index)
  end
  def test_get_frame_type1
    index = @method.has_local(:local_bar)
    assert_equal :Integer , @method.frame_type(index)
  end
  def test_get_locals_name2
    index = @method.has_local(:local_foo)
    assert_equal 2 , index
    assert_equal :local_foo , @method.locals_name(index)
  end
  def test_get_frame_type2
    index = @method.has_local(:local_bar)
    assert_equal :Integer , @method.frame_type(index)
  end

end
