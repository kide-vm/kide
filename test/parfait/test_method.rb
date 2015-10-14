require_relative "../helper"

class TestMethod < MiniTest::Test

  def setup
    obj = Virtual.machine.boot.space.get_class_by_name(:Object)
    args = Virtual.new_list [ Parfait::Variable.new(:Integer , :bar )]
    @method = ::Parfait::Method.new obj , :foo , args
  end

  def test_method_name
    assert_equal :foo , @method.name
  end

  def test_arg1
    assert_equal 1 , @method.arguments.get_length
    assert_equal Parfait::Variable , @method.arguments.first.class
    assert_equal :bar , @method.arguments.first.name
  end
  def test_has_arg
    assert_equal 1 , @method.has_arg(:bar)
  end
end
