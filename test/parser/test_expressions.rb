require_relative "helper"

class TestBasic < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
    
  def test_expression_else
    @string_input    = <<HERE
4
5
else
HERE
    @parse_output = {:expressions=>[{:integer=>"4"}, {:integer=>"5"}]}
    @transform_output = {:expressions=>[ Parser::IntegerExpression.new(4), Parser::IntegerExpression.new(5)]}
    @parser = @parser.expressions_else
  end

  def test_expression_end
    @string_input    = <<HERE
5
name
call(4,6)
end
HERE
    @parse_output = {:expressions => [ { :integer => "5" }, 
                  { :name => "name" }, 
                  { :function_call => { :name => "call" } , 
                    :argument_list => [ {:argument => { :integer => "4" } } , 
                                        {:argument => { :integer => "6" } } ] } ]}
    args = [ Parser::IntegerExpression.new(4) , Parser::IntegerExpression.new(6) ]
    @transform_output = {:expressions=>[ Parser::IntegerExpression.new(5), 
                                        Parser::NameExpression.new("name") ,
                                        Parser::FuncallExpression.new("call", args ) ] }

    @parser = @parser.expressions_end
  end

end