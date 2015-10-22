require_relative "../helper"

class TestLayout < MiniTest::Test

  def setup
    @mess = Register.machine.boot.space.first_message
  end

  def test_message_layout
    layout = @mess.get_layout
    assert layout
    assert @mess.instance_variable_defined :next_message
    assert_equal @mess.next_message , @mess.get_instance_variable(:next_message)
  end

  def test_message_by_index
    assert_equal @mess.next_message , @mess.get_instance_variable(:next_message)
    index = @mess.get_layout.variable_index :next_message
    assert_equal 2 , index
    assert_equal @mess.next_message , @mess.internal_object_get(index)
  end

  def test_layout_index
    assert_equal @mess.get_layout , @mess.internal_object_get(1) , "mess"
  end

  def test_forbidden_index_of
    assert_raises(RuntimeError) { @mess.get_layout.index_of(:name)}
  end

  def test_inspect
    assert @mess.get_layout.inspect.start_with?("Layout")
  end
  def test_layout_is_first
    layout = @mess.get_layout
    assert_equal 1 , layout.variable_index(:layout)
  end

  def test_no_index_below_1
    layout = @mess.get_layout
    names = layout.object_instance_names
    assert_equal 7 , names.get_length , names.inspect
    names.each do |n|
      assert layout.variable_index(n) >= 1
    end
  end

  def test_class_layout
    oc = Register.machine.boot.space.get_class_by_name( :Object )
    assert_equal Parfait::Class , oc.class
    layout = oc.object_layout
    assert_equal Parfait::Layout , layout.class
    assert_equal layout.object_instance_names.get_length , 0
    #assert_equal layout.first , :layout
  end

  def test_attribute_set
    @mess.receiver = 55
    assert_equal 55 , @mess.receiver
  end

  # not really parfait test, but related and no other place currently
  def test_reg_index
    message_ind = Register.resolve_index( :message , :receiver )
    assert_equal 3 , message_ind
    @mess.receiver = 55
    assert_equal 55 , @mess.internal_object_get(message_ind)
  end

  def test_object_layout
    assert_equal 2 , @mess.get_layout.variable_index(:next_message)
  end

  def test_remove_me
    layout = @mess.get_layout
    assert_equal layout , @mess.internal_object_get(1)
  end
end
