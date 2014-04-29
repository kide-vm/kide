require_relative 'helper'

# Please read note in test_parser

class TransformTest <  MiniTest::Test

  def setup
    @transform = Parser::Transform.new
  end

  def check
    is = @transform.apply @input
    #puts is.transform
    assert_equal @transform_output , is
  end
  def test_number
    @input    = {:integer => '42'}
    @transform_output = Parser::IntegerExpression.new(42)
    check
    assert_equal 42 , @transform_output.value
  end

  def test_name
    @input    = {:name => 'foo'}
    @transform_output = Parser::NameExpression.new('foo')
    check
  end

  def test_string
    @input    =  {:string=>"hello"}
    @transform_output =  Parser::StringExpression.new('hello')
    check
  end

  def test_argument_list
    @input    = {:argument_list => [{:argument => {:integer => '42'}},
                          {:argument => {:name   => 'foo'}}]}
    @transform_output = [Parser::IntegerExpression.new(42),
                Parser::NameExpression.new('foo')]
    check
  end

  def test_single_argument
    @input = {:function_call => {:name => 'foo'},
             :argument_list    => {:argument => {:integer => '42'} } }
    @transform_output = Parser::FuncallExpression.new 'foo', [Parser::IntegerExpression.new(42)]

    check
  end

  def test_multi_argument
    @input = {:function_call => {:name => 'baz'},
             :argument_list    => [{:argument => {:integer => '42'}},
                          {:argument => {:name => 'foo'}}]}
    @transform_output = Parser::FuncallExpression.new 'baz', [Parser::IntegerExpression.new(42),
                                          Parser::NameExpression.new('foo')]

    check
  end

  def test_conditional
    @input = { :conditional => { :integer => "0"}, 
                  :if_true => {  :expressions => [ { :integer => "42" } ] } , 
                  :if_false => { :expressions => [ { :integer => "667" } ] } }
    @transform_output = Parser::ConditionalExpression.new(  Parser::IntegerExpression.new(0),
                                                [Parser::IntegerExpression.new(42)],
                                                [Parser::IntegerExpression.new(667)])
    check
  end

  def test_parmeter
    @input = {:parmeter => { :name => "foo"}} 
    @transform_output = Parser::NameExpression.new('foo')
    check
  end
  def test_parmeter_list
    @input = {:parmeter_list => [{:parmeter => { :name => "foo"}}]}
    @transform_output = [Parser::NameExpression.new('foo')]
    check
  end
  
  def test_function_definition
    @input = {:function_definition   => {:name => 'foo'},
                :parmeter_list => {:parmeter => {:name => 'x'}},
                :expressions   => [{:integer => '5'}]}
    @transform_output = Parser::FunctionExpression.new('foo', 
                [Parser::NameExpression.new('x')], 
                [Parser::IntegerExpression.new(5)])
    check
  end

  def test_function_assignment
    @input = { :function_definition => { :name => "foo" } , 
                  :parmeter_list => { :parmeter => { :name => "x" } }, 
                  :expressions => [ { :asignee => { :name => "abba" }, :asigned => { :integer => "5" } } ]
                }
    @transform_output = Parser::FunctionExpression.new( "foo", [Parser::NameExpression.new("x")],
                           [Parser::AssignmentExpression.new( "abba", Parser::IntegerExpression.new(5) ) ])
    check
  end

  def test_assignment
    @input =   { :asignee => { :name=>"a" } , :asigned => { :integer => "5" } }
    @transform_output = Parser::AssignmentExpression.new("a", Parser::IntegerExpression.new(5) )
    check
  end
end
