require_relative "../helper"

class TypeApi < MiniTest::Test

  def setup
    Register.machine.boot
    @space = Parfait.object_space
    tc = @space.get_class_by_name( :Type )
    @type = Parfait::Type.new tc
  end

  def test_inspect
    assert @type.inspect.start_with?("Type")
  end

  def test_class_type
    oc = @space.get_class_by_name( :Object )
    assert_equal Parfait::Class , oc.class
    type = oc.instance_type
    assert_equal Parfait::Type , type.class
    assert_equal 1 , type.names.get_length , type.names.inspect
    assert_equal type.names.first , :type
  end

  def test_class_space
    space = Parfait.object_space
    assert_equal Parfait::Space , space.class
    type = space.get_type
    assert_equal Parfait::Type , type.class
    assert_equal 4 , type.names.get_length
    assert_equal type.object_class.class , Parfait::Class
    assert_equal type.object_class.name , :Space
  end

  def test_add_name
    t = @type.add_instance_variable( :boo , :Object)
    assert t
    t
  end

  def test_added_name_length
    type = test_add_name
    assert_equal 2 , type.names.get_length , type.inspect
    assert_equal :type , type.names.get(1)
    assert_equal :boo , type.names.get(2)
  end

  def test_added_name_index
    type = test_add_name
    assert_equal 2 , type.variable_index(:boo)
    assert_equal :Object , type.type_at(2)
  end

  def test_basic_var_index
    assert_equal 1 , @type.variable_index(:type)
  end
  def test_basic_type_index
    assert_equal :Type , @type.type_at(1)
  end

  def test_inspect_added
    type = test_add_name
    assert type.inspect.include?("boo") , type.inspect
  end

  def test_added_names
    type = test_add_name
    assert_equal :type , type.names.get(1)
    assert_equal :boo , type.names.get(2)
    assert_equal 2 , type.names.get_length
  end

  def test_each_name
    type = test_add_name
    assert_equal 2 , type.get_length
    counter = [ :boo  , :type ]
    type.names.each do |item|
      assert_equal item , counter.delete(item)
    end
    assert counter.empty? , counter.inspect
  end

  def test_each_type
    type = test_add_name
    assert_equal 2 , type.get_length
    counter = [  :Object  , :Type]
    type.types.each do |item|
      assert_equal item , counter.delete(item)
    end
    assert counter.empty? , counter.inspect
  end

end
