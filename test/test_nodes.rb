$: << File.expand_path(File.dirname(__FILE__) + '/../lib')
$: << File.expand_path(File.dirname(__FILE__))

require 'minitest/autorun'
require 'minitest/spec'
require 'vm/nodes'

include Vm

class FakeBuilder
  attr_reader :result

  def initialize
    @result = ''
  end

  def class_builder
    'example'
  end

  def int
    'int'
  end

  def method_missing(name, *args, &block)
    @result += ([name] + args.flatten).join(', ').sub(',', '')
    @result += "\n"
    block.call(self) if name.to_s == 'public_static_method'
  end
end

describe 'Nodes' do
  before do
    @context = Hash.new
    @builder = FakeBuilder.new
  end

  it 'emits a number' do
    input    = Vm::Number.new 42
    expected = <<HERE
mov r0, 42
HERE
    input.eval @context, @builder

    @builder.result.must_equal expected
  end

  it 'emits a function call' do
    @context[:params] = ['foo']

    input    = Vm::Funcall.new 'baz', [Vm::Number.new(42),
                                          Vm::Name.new('foo')]
    expected = <<HERE
mov r0, 42
iload 0
invokestatic example, baz, int, int, int
HERE

    input.eval @context, @builder

    @builder.result.must_equal expected
  end

  it 'emits a conditional' do
    input    = Vm::Conditional.new \
      Vm::Number.new(0),
      Vm::Number.new(42),
      Vm::Number.new(667)
    expected = <<HERE
mov r0, 0
ifeq else
mov r0, 42
goto endif
label else
mov r0, 667
label endif
HERE

    input.eval @context, @builder
    @builder.result.must_equal expected
  end

  it 'emits a function definition' do
    input    = Vm::Function.new \
      'foo',
      Vm::Name.new('x'),
      Vm::Number.new(5)

    expected = <<HERE
public_static_method foo, int, int
mov r0, 5
ireturn
HERE

    input.eval @context, @builder
    @builder.result.must_equal expected
  end
end
