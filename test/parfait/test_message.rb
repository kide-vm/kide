require_relative "../helper"

class TestMessage < MiniTest::Test

  def setup
    Risc.machine.boot
    @space = Parfait.object_space
    @mess = @space.first_message
  end

  def test_length
    assert_equal 9 , @mess.get_type.instance_length , @mess.get_type.inspect
  end

  def test_attribute_set
    @mess.set_receiver( 55)
    assert_equal 55 , @mess.receiver
  end

  def test_indexed
    assert_equal 9 , @mess.get_type.variable_index(:arguments)
  end

  def test_next
    assert @mess.next_message
  end
end
