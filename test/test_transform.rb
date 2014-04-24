require_relative 'helper'
require 'minitest/spec'
require 'vm/transform'

include Vm

describe Transform do
  before do
    @transform = Vm::Transform.new
  end

  it 'transforms a number' do
    input    = {:number => '42'}
    expected = Vm::NumberExpression.new(42)

    @transform.apply(input).must_equal expected
  end

  it 'transforms a name' do
    input    = {:name => 'foo'}
    expected = Vm::NameExpression.new('foo')

    @transform.apply(input).must_equal expected
  end

  it 'transforms an argument list' do
    input    = {:args => [{:arg => {:number => '42'}},
                          {:arg => {:name   => 'foo'}}]}
    expected = [Vm::NumberExpression.new(42),
                Vm::NameExpression.new('foo')]

    @transform.apply(input).must_equal expected
  end

  it 'transforms a single-argument function call' do
    input = {:funcall => {:name => 'foo'},
             :args    => [{:arg => {:number => '42'}}]}
    expected = Vm::FuncallExpression.new 'foo', [Vm::NumberExpression.new(42)]

    @transform.apply(input).must_equal expected
  end

  it 'transforms a multi-argument function call' do
    input = {:funcall => {:name => 'baz'},
             :args    => [{:arg => {:number => '42'}},
                          {:arg => {:name => 'foo'}}]}
    expected = Vm::FuncallExpression.new 'baz', [Vm::NumberExpression.new(42),
                                          Vm::NameExpression.new('foo')]

    @transform.apply(input).must_equal expected
  end

  it 'transforms a conditional' do
    input = {:cond     => {:number => '0'},
             :if_true  => {:body => {:number => '42'}},
             :if_false => {:body => {:number => '667'}}}
    expected = Vm::ConditionalExpression.new \
      Vm::NumberExpression.new(0),
      Vm::NumberExpression.new(42),
      Vm::NumberExpression.new(667)

    @transform.apply(input).must_equal expected
  end

  it 'transforms a function definition' do
    input = {:func   => {:name => 'foo'},
             :params => {:param => {:name => 'x'}},
             :body   => {:number => '5'}}
    expected = Vm::FunctionExpression.new \
      'foo',
      [Vm::NameExpression.new('x')],
      Vm::NumberExpression.new(5)

    @transform.apply(input).must_equal expected
  end
end
