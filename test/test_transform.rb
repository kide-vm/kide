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

  def test_conditional
    @input = { :conditional => { :integer => "0"}, 
                  :if_true => {  :expressions => [ { :integer => "42" } ] } , 
                  :if_false => { :expressions => [ { :integer => "667" } ] } }
    @transform_output = Parser::ConditionalExpression.new(  Parser::IntegerExpression.new(0),
                                                [Parser::IntegerExpression.new(42)],
                                                [Parser::IntegerExpression.new(667)])
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
