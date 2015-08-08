require_relative "../helper"

class TestLayout < MiniTest::Test

  def setup
    @mess = Virtual.machine.boot.space.first_message
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

  def test_no_index_below_2
    layout = @mess.get_layout
    names = layout.object_instance_names
    assert_equal 7 , names.get_length
    names.each do |n|
      assert layout.variable_index(n) > 1
    end
  end

end
