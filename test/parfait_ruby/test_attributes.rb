require_relative "../helper"

class TestAttributes < MiniTest::Test

  def setup
    @mess = Register.machine.boot.space.first_message
    @layout = @mess.get_layout
  end

  def test_message_get_layout
    assert_equal Parfait::Layout , @layout.class
  end
  def test_message_layout_first
    @layout.object_class = :next_message
    assert_equal :layout , @layout.instance_names.first
    assert_equal :next_message , @layout.object_class
  end
  def test_message_name_nil
    last = @layout.instance_names.last
    assert_equal :indexed_length , last
    assert_equal nil , @mess.name
  end
  def test_message_next_set
    @mess.next_message = :next_message
    assert_equal :next_message , @mess.next_message
  end
  def test_message_layout_set
    @mess.set_layout :layout
    assert_equal :layout , @mess.get_layout
  end
  def test_attribute_index
    @mess.next_message = :message
    assert_equal Parfait::Layout , @mess.get_layout.class
  end
  def test_layout_attribute
    @layout.object_class = :message
    assert_equal :message , @layout.object_class
  end
  def test_layout_attribute_check
    @layout.object_class = :message
    assert_equal Parfait::Layout , @layout.get_layout.class
  end
  def test_layout_layout
    assert_equal Parfait::Layout , @layout.get_layout.get_layout.class
  end
  def test_layout_layout_layout
    assert_equal Parfait::Layout , @layout.get_layout.get_layout.get_layout.class
  end
end
