require_relative "helper"
require 'minitest/spec'

include Vm

class FakeBuilder
  attr_reader :result

  Asm::InstructionTools::REGISTERS.each do |reg , number|
    define_method(reg) { Asm::Register.new(reg , number) }
  end

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
    input    = Vm::NumberExpression.new 42
    expected = <<HERE
mov r0, 42
HERE
    input.eval @context, @builder

    @builder.result.must_equal expected
  end

  it 'emits a function call' do
    @context[:params] = ['foo']

    input    = Vm::FuncallExpression.new 'baz', [Vm::NumberExpression.new(42),
                                          Vm::NameExpression.new('foo')]
    expected = <<HERE
mov r0, 42
iload 0
invokestatic example, baz, int, int, int
HERE

    input.eval @context, @builder

    @builder.result.must_equal expected
  end

  it 'emits a conditional' do
    input    = Vm::ConditionalExpression.new \
      Vm::NumberExpression.new(0),
      Vm::NumberExpression.new(42),
      Vm::NumberExpression.new(667)
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
    input    = Vm::FunctionExpression.new \
      'foo',
      Vm::NameExpression.new('x'),
      Vm::NumberExpression.new(5)

    expected = <<HERE
public_static_method foo, int, int
mov r0, 5
ireturn
HERE

    input.eval @context, @builder
    @builder.result.must_equal expected
  end
end
