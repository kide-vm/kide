require_relative 'helper'

class TransformTest <  MiniTest::Test

  def setup
    @transform = Parser::Transform.new
  end

  def check_equals
    is = @transform.apply @input
    assert_equal @expected , is
  end
  def test_number
    @input    = {:integer => '42'}
    @expected = Parser::IntegerExpression.new(42)
    check_equals
    assert_equal 42 , @expected.value
  end

  def test_name
    @input    = {:name => 'foo'}
    @expected = Parser::NameExpression.new('foo')
    check_equals
  end

  def test_argument_list
    @input    = {:argument_list => [{:argument => {:integer => '42'}},
                          {:argument => {:name   => 'foo'}}]}
    @expected = [Parser::IntegerExpression.new(42),
                Parser::NameExpression.new('foo')]
    check_equals
  end

  def test_single_argument
    @input = {:function_call => {:name => 'foo'},
             :argument_list    => {:argument => {:integer => '42'} } }
    @expected = Parser::FuncallExpression.new 'foo', [Parser::IntegerExpression.new(42)]

    check_equals
  end

  def test_multi_argument
    @input = {:function_call => {:name => 'baz'},
             :argument_list    => [{:argument => {:integer => '42'}},
                          {:argument => {:name => 'foo'}}]}
    @expected = Parser::FuncallExpression.new 'baz', [Parser::IntegerExpression.new(42),
                                          Parser::NameExpression.new('foo')]

    check_equals
  end

  def test_conditional
    @input = { :conditional => { :integer => "0"}, 
                  :if_true => {  :expressions => [ { :integer => "42" } ] } , 
                  :if_false => { :expressions => [ { :integer => "667" } ] } }
    @expected = Parser::ConditionalExpression.new(  Parser::IntegerExpression.new(0),
                                                [Parser::IntegerExpression.new(42)],
                                                [Parser::IntegerExpression.new(667)])
    check_equals
  end

  def test_parmeter
    @input = {:parmeter => { :name => "foo"}} 
    @expected = Parser::NameExpression.new('foo')
    check_equals
  end
  def test_parmeter_list
    @input = {:parmeter_list => [{:parmeter => { :name => "foo"}}]}
    @expected = [Parser::NameExpression.new('foo')]
    check_equals
  end
  
  def test_function_definition
    @input = {:function_definition   => {:name => 'foo'},
                :parmeter_list => {:parmeter => {:name => 'x'}},
                :expressions   => [{:integer => '5'}]}
    @expected = Parser::FunctionExpression.new('foo', 
                [Parser::NameExpression.new('x')], 
                [Parser::IntegerExpression.new(5)])
    check_equals
  end

  def test_assignment
    @input =   { :asignee => { :name=>"a" } , :asigned => { :integer => "5" } }
    @expected = Parser::AssignmentExpression.new("a", Parser::IntegerExpression.new(5) )
    check_equals
  end
end
