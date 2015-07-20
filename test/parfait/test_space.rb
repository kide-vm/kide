require_relative "../helper"

class TestSpace < MiniTest::Test

  def setup
    @machine = Virtual.machine
    @machine.boot
  end
  def test_booted
    assert_equal true , @machine.booted
  end
  def test_machine_space
    assert_equal Parfait::Space , @machine.space.class
  end
  def test_global_space
    assert_equal Parfait::Space , Parfait::Space.object_space.class
  end
  def test_classes
    [:Kernel,:Word,:List,:Message,:Frame,:Layout,:Class,:Dictionary,:Method].each do |name|
      assert_equal :Class , @machine.space.classes[name].get_class.name
      assert_equal Parfait::Class , @machine.space.classes[name].class
      assert_equal Parfait::Layout , @machine.space.classes[name].get_layout.class
    end
  end
  def test_messages
    mess = @machine.space.first_message
    all = []
    while mess
      all << mess
      assert mess.frame
      mess = mess.next_message
    end
    assert_equal all.length , all.uniq.length
    # there is a 5.times in space, but one Message gets created before
    assert_equal  5 + 1 , all.length
  end
  def test_message_vars
    mess = @machine.space.first_message
    all = mess.get_instance_variables
    assert all
    assert all.include?(:next_message)
  end

  def test_message_layout
    mess = @machine.space.first_message
    one_way = mess.get_layout
    assert one_way
    assert mess.instance_variable_defined :next_message
#    other_way = mess.get_instance_variable :layout
#    assert other_way
#    assert_equal one_way , other_way , "not same "

  end
end
