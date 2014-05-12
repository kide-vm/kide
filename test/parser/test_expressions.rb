require_relative "helper"

class TestExpressions < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
    
  def test_expression_else
    @string_input    = <<HERE
dud
fuu(3)
else
HERE
    @string_input.chop!
    @parse_output = {:expressions=>[{:name=>"dud"}, 
      {:function_call=>{:name=>"fuu"}, :argument_list=>[{:argument=>{:integer=>"3"}}]}], 
      :else=>"else"}
    @transform_output ={:expressions=>[Ast::NameExpression.new("dud"), 
          Ast::FuncallExpression.new("fuu", [Ast::IntegerExpression.new(3)] )], :else=>"else"}
    @parser = @parser.expressions_else
  end

  def test_expression_end
    @string_input    = <<HERE
name
call(4,6)
end
HERE
    @string_input.chop!
    @parse_output = {:expressions=>[{:name=>"name"}, 
      {:function_call=>{:name=>"call"}, :argument_list=>[{:argument=>{:integer=>"4"}}, {:argument=>{:integer=>"6"}}]}], 
      :end=>"end"}
    @transform_output = {:expressions=>[Ast::NameExpression.new("name"), 
      Ast::FuncallExpression.new("call", [Ast::IntegerExpression.new(4),Ast::IntegerExpression.new(6)] )], 
      :end=>"end"}

    @parser = @parser.expressions_end
  end


end