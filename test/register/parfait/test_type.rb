require_relative "../helper"

class TestType < MiniTest::Test

  def setup
    @mess = Register.machine.boot.space.first_message
  end

  def test_message_type
    type = @mess.get_type
    assert type
    assert @mess.instance_variable_defined :next_message
    assert_equal @mess.next_message , @mess.get_instance_variable(:next_message)
  end

  def test_message_by_index
    assert_equal @mess.next_message , @mess.get_instance_variable(:next_message)
    index = @mess.get_type.variable_index :next_message
    assert_equal 2 , index
    assert_equal @mess.next_message , @mess.get_internal_word(index)
  end

  def test_type_index
    assert_equal @mess.get_type , @mess.get_internal_word(Parfait::TYPE_INDEX) , "mess"
  end

  def test_inspect
    assert @mess.get_type.inspect.start_with?("Type")
  end
  def test_type_is_first
    type = @mess.get_type
    assert_equal 1 , type.variable_index(:type)
  end

  def test_length
    assert_equal 9 , @mess.get_type.instance_length , @mess.get_type.inspect
  end

  def test_type_length
    assert_equal 9 , @mess.get_type.instance_length , @mess.get_type.inspect
    assert_equal 18 , @mess.get_type.get_internal_word(4)
  end

  def test_type_length_index
    assert_equal 4 , @mess.get_type.get_type.variable_index(:indexed_length)
    assert_equal 4 , @mess.get_type.get_type.get_offset
    assert_equal 4 , @mess.get_type.get_offset
    assert_equal 8 , @mess.get_type.get_type.indexed_length
    assert_equal 8 , @mess.get_type.get_type.get_internal_word(4)
  end

  def test_type_methods
    assert_equal 3 , @mess.get_type.get_type.variable_index(:instance_methods)
  end

  def test_no_index_below_1
    type = @mess.get_type
    names = type.instance_names
    assert_equal 9 , names.get_length , names.inspect
    names.each do |n|
      assert type.variable_index(n) >= 1
    end
  end

  def test_class_type
    oc = Register.machine.boot.space.get_class_by_name( :Object )
    assert_equal Parfait::Class , oc.class
    type = oc.instance_type
    assert_equal Parfait::Type , type.class
    assert_equal 1 , type.instance_names.get_length
    assert_equal type.first , :type
  end


  def test_class_space
    space = Register.machine.space
    assert_equal Parfait::Space , space.class
    type = space.get_type
    assert_equal Parfait::Type , type.class
    assert_equal 3 , type.instance_names.get_length
    assert_equal type.object_class.class , Parfait::Class
    assert_equal type.object_class.name , :Space
  end
  def test_attribute_set
    @mess.receiver = 55
    assert_equal 55 , @mess.receiver
  end

  def test_add_name
    type = Parfait::Type.new Register.machine.space.get_class_by_name(:Type)
    type.add_instance_variable :boo , :Object
    assert_equal 2 , type.variable_index(:boo)
    assert_equal 4 , type.get_length
    assert_equal :type , type.get(1)
    assert_equal :boo , type.get(3)
    type
  end

  def test_inspect
    type = test_add_name
    assert type.inspect.include?("boo") , type.inspect
  end

  def test_each
    type = test_add_name
    assert_equal 4 , type.get_length
    counter = [:boo , :Object, :type , :Type]
    type.each do |item|
      assert_equal item , counter.delete(item)
    end
    assert counter.empty?
  end

  # not really parfait test, but related and no other place currently
  def test_reg_index
    message_ind = Register.resolve_index( :message , :receiver )
    assert_equal 3 , message_ind
    @mess.receiver = 55
    assert_equal 55 , @mess.get_internal_word(message_ind)
  end

  def test_instance_type
    assert_equal 2 , @mess.get_type.variable_index(:next_message)
  end

  def test_remove_me
    type = @mess.get_type
    assert_equal type , @mess.get_internal_word(1)
  end
end
