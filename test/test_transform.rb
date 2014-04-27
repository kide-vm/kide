require_relative 'helper'

include Vm

class TransformTest <  MiniTest::Test

  def setup
    @transform = Parser::Transform.new
  end

  def check_equals
    is = @transform.apply @input
    assert_equal @expected.class , is.class
  end
  def test_number
    @input    = {:integer => '42'}
    @expected = Vm::IntegerExpression.new(42)
    check_equals
    assert_equal 42 , @expected.value
  end

  def test_name
    @input    = {:name => 'foo'}
    @expected = Vm::NameExpression.new('foo')
    check_equals
  end

  def test_argument_list
    @input    = {:argument_list => [{:argument => {:integer => '42'}},
                          {:argument => {:name   => 'foo'}}]}
    @expected = [Vm::IntegerExpression.new(42),
                Vm::NameExpression.new('foo')]
    check_equals
  end

  def test_single_argument
    @input = {:function_call => {:name => 'foo'},
             :argument_list    => [{:argument => {:integer => '42'}}]}
    @expected = Vm::FuncallExpression.new 'foo', [Vm::IntegerExpression.new(42)]

    check_equals
  end

  def test_multi_argument
    @input = {:function_call => {:name => 'baz'},
             :argument_list    => [{:argument => {:integer => '42'}},
                          {:argument => {:name => 'foo'}}]}
    @expected = Vm::FuncallExpression.new 'baz', [Vm::IntegerExpression.new(42),
                                          Vm::NameExpression.new('foo')]

    check_equals
  end

  def test_conditional
    @input = {:cond     => {:integer => '0'},
             :if_true  => {:block => {:integer => '42'}},
             :if_false => {:block => {:integer => '667'}}}
    @expected = Vm::ConditionalExpression.new \
      Vm::IntegerExpression.new(0),
      Vm::IntegerExpression.new(42),
      Vm::IntegerExpression.new(667)
    check_equals
  end

  def test_param
    @input = {:param => { :name => "foo"}} 
    @expected = Vm::NameExpression.new('foo')
    check_equals
  end
  def test_params
    @input = {:params => [{:param => { :name => "foo"}}]}
    @expected = [Vm::NameExpression.new('foo')]
    check_equals
  end
  
  def test_function_definition
    @input = {:function_definition => { :name => "foo"}, 
      :params => [{ :param => { :name => "x" }}] , 
      :block => { :integer => "5" }}
    @expected = Vm::FunctionExpression.new('foo', [Vm::NameExpression.new('x')], Vm::IntegerExpression.new(5))
    check_equals
  end
end
