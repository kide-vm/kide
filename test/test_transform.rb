require_relative 'helper'
require 'vm/transform'

include Vm

class TransformTest <  MiniTest::Test

  def setup
    @transform = Vm::Transform.new
  end

  def check_equals
    is = @transform.apply @input
    assert_equal @expected.class , is.class
  end
  def test_number
    @input    = {:number => '42'}
    @expected = Vm::NumberExpression.new(42)
    check_equals
    assert_equal 42 , @expected.value
  end

  def test_name
    @input    = {:name => 'foo'}
    @expected = Vm::NameExpression.new('foo')
    check_equals
  end

  def test_argument_list
    @input    = {:args => [{:arg => {:number => '42'}},
                          {:arg => {:name   => 'foo'}}]}
    @expected = [Vm::NumberExpression.new(42),
                Vm::NameExpression.new('foo')]
    check_equals
  end

  def test_single_argument
    @input = {:funcall => {:name => 'foo'},
             :args    => [{:arg => {:number => '42'}}]}
    @expected = Vm::FuncallExpression.new 'foo', [Vm::NumberExpression.new(42)]

    check_equals
  end

  def test_multi_argument
    @input = {:funcall => {:name => 'baz'},
             :args    => [{:arg => {:number => '42'}},
                          {:arg => {:name => 'foo'}}]}
    @expected = Vm::FuncallExpression.new 'baz', [Vm::NumberExpression.new(42),
                                          Vm::NameExpression.new('foo')]

    check_equals
  end

  def test_conditional
    @input = {:cond     => {:number => '0'},
             :if_true  => {:body => {:number => '42'}},
             :if_false => {:body => {:number => '667'}}}
    @expected = Vm::ConditionalExpression.new \
      Vm::NumberExpression.new(0),
      Vm::NumberExpression.new(42),
      Vm::NumberExpression.new(667)

    check_equals
  end

  def test__function_definition
    @input = {:func   => {:name => 'foo'},
             :params => {:param => {:name => 'x'}},
             :body   => {:number => '5'}}
    @expected = Vm::FunctionExpression.new \
      'foo',
      [Vm::NameExpression.new('x')],
      Vm::NumberExpression.new(5)

      check_equals
  end
end
