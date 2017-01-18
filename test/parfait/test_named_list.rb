require_relative "../helper"

class TestNamedLists < MiniTest::Test

  def setup
    Register.machine.boot
    @space = Parfait.object_space
    @named_list = @space.first_message.locals
    @type = @named_list.get_type
  end

  def test_named_list_get_type
    assert_equal Parfait::Type , @type.class
    assert @type.names
    assert @named_list.get_instance_variables
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
