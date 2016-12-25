require_relative "../helper"

class TestNamedLists < MiniTest::Test

  def setup
    @named_list = Register.machine.boot.space.first_message.locals
    @type = @named_list.get_type
  end

  def test_named_list_get_type
    assert_equal Parfait::Type , @type.class
    assert @type.instance_names
    assert @named_list.get_instance_variables
  end

  def test_named_list_next_set
    @named_list.next_list = :next_list
    assert_equal :next_list , @named_list.next_list
  end

  def test_new
    list = Parfait::NamedList.new
    assert list.get_type
  end

  def test_var_names
    list = Parfait::NamedList.new
    assert list.get_instance_variables
  end
end
