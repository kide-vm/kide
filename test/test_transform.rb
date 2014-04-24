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
    expected = Vm::Number.new(42)

    @transform.apply(input).must_equal expected
  end

  it 'transforms a name' do
    input    = {:name => 'foo'}
    expected = Vm::Name.new('foo')

    @transform.apply(input).must_equal expected
  end

  it 'transforms an argument list' do
    input    = {:args => [{:arg => {:number => '42'}},
                          {:arg => {:name   => 'foo'}}]}
    expected = [Vm::Number.new(42),
                Vm::Name.new('foo')]

    @transform.apply(input).must_equal expected
  end

  it 'transforms a single-argument function call' do
    input = {:funcall => {:name => 'foo'},
             :args    => [{:arg => {:number => '42'}}]}
    expected = Vm::Funcall.new 'foo', [Vm::Number.new(42)]

    @transform.apply(input).must_equal expected
  end

  it 'transforms a multi-argument function call' do
    input = {:funcall => {:name => 'baz'},
             :args    => [{:arg => {:number => '42'}},
                          {:arg => {:name => 'foo'}}]}
    expected = Vm::Funcall.new 'baz', [Vm::Number.new(42),
                                          Vm::Name.new('foo')]

    @transform.apply(input).must_equal expected
  end

  it 'transforms a conditional' do
    input = {:cond     => {:number => '0'},
             :if_true  => {:body => {:number => '42'}},
             :if_false => {:body => {:number => '667'}}}
    expected = Vm::Conditional.new \
      Vm::Number.new(0),
      Vm::Number.new(42),
      Vm::Number.new(667)

    @transform.apply(input).must_equal expected
  end

  it 'transforms a function definition' do
    input = {:func   => {:name => 'foo'},
             :params => {:param => {:name => 'x'}},
             :body   => {:number => '5'}}
    expected = Vm::Function.new \
      'foo',
      [Vm::Name.new('x')],
      Vm::Number.new(5)

    @transform.apply(input).must_equal expected
  end
end
