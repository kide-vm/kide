require_relative "../helper"

class TypeApi < MiniTest::Test

  def setup
    tc = Register.machine.boot.space.get_class_by_name( :Type )
    @type = Parfait::Type.new tc
  end

  def test_inspect
    assert @type.inspect.start_with?("Type")
  end

  def test_class_type
    oc = Register.machine.boot.space.get_class_by_name( :Object )
    assert_equal Parfait::Class , oc.class
    type = oc.instance_type
    assert_equal Parfait::Type , type.class
    assert_equal 1 , type.instance_names.get_length , type.instance_names.inspect
    assert_equal type.first , :type
  end

  def test_class_space
    space = Register.machine.space
    assert_equal Parfait::Space , space.class
    type = space.get_type
    assert_equal Parfait::Type , type.class
    assert_equal 4 , type.instance_names.get_length
    assert_equal type.object_class.class , Parfait::Class
    assert_equal type.object_class.name , :Space
  end

  def test_add_name
    @type.add_instance_variable( :boo , :Object)
  end

  def test_added_name_length
    type = test_add_name
    assert_equal 4 , type.get_length , type.inspect
    assert_equal :type , type.get(1)
    assert_equal :boo , type.get(3)
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
    assert_equal :type , type.instance_names.get(1)
    assert_equal :boo , type.instance_names.get(2)
    assert_equal 2 , type.instance_names.get_length
  end

  def test_each
    type = test_add_name
    assert_equal 4 , type.get_length
    counter = [ :boo , :Object , :type , :Type]
    type.each do |item|
      assert_equal item , counter.delete(item)
    end
    assert counter.empty? , counter.inspect
  end

end
