require_relative "helper"

class TestWhile < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper

  def test_while
    @string_input = <<HERE
while(1) do
  tmp = a
  puts(b)
end
HERE

    @parse_output = {:while=>"while", 
                    :while_cond=>{:integer=>"1"}, 
                    :do=>"do", 
                    :body=>{:expressions=>[{:l=>{:name=>"tmp"}, :o=>"= ", :r=>{:name=>"a"}}, 
              {:function_call=>{:name=>"puts"}, :argument_list=>[{:argument=>{:name=>"b"}}]}], :end=>"end"}}
    @transform_output = Ast::WhileExpression.new(
            Ast::IntegerExpression.new(1), 
            [Ast::OperatorExpression.new("=", Ast::NameExpression.new("tmp"),Ast::NameExpression.new("a")), 
              Ast::FuncallExpression.new("puts", [Ast::NameExpression.new("b")] )] )
    @parser = @parser.while_do
  end
end