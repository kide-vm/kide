require_relative "../helper"

class BasicType < MiniTest::Test

  def setup
    Register.machine.boot
    @space = Parfait::Space.object_space
    @mess = @space.first_message
    assert @mess
    @type = @mess.get_type()
  end

  def test_type_index
    assert_equal @mess.get_type , @mess.get_internal_word(Parfait::TYPE_INDEX) , "mess"
  end

  def test_type_is_first
    type = @mess.get_type
    assert_equal 1 , type.variable_index(:type)
  end

  def test_length
    assert @mess
    assert @mess.get_type
    assert_equal 9 , @mess.get_type.instance_length , @mess.get_type.inspect
  end

  def test_names
    assert @type.names
  end
  def test_types
    assert @type.types
  end

  def test_type_length
    assert_equal 9 , @mess.get_type.instance_length , @mess.get_type.inspect
  end

  def test_type_length_index
    type = @mess.get_type.get_type
    assert_equal 5 , type.variable_index(:methods)
    assert_equal type.object_class , type.get_internal_word(4)
  end

  def test_no_index_below_1
    type = @mess.get_type
    names = type.names
    assert_equal 9 , names.get_length , names.inspect
    names.each do |n|
      assert type.variable_index(n) >= 1
    end
  end

  def test_attribute_set
    @mess.set_receiver( 55)
    assert_equal 55 , @mess.receiver
  end

  # not really parfait test, but related and no other place currently
  def test_reg_index
    message_ind = Register.resolve_to_index( :message , :receiver )
    assert_equal 3 , message_ind
    @mess.set_receiver( 55)
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
