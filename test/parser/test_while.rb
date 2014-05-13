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
    @string_input.chop!
    @parse_output = {:while=>"while", 
                    :while_cond=>{:integer=>"1"}, 
                    :do=>"do", 
                    :body=>{:expressions=>[{:l=>{:name=>"tmp"}, :o=>"= ", :r=>{:name=>"a"}}, 
              {:call_site=>{:name=>"puts"}, :argument_list=>[{:argument=>{:name=>"b"}}]}], :end=>"end"}}
    @transform_output = Ast::WhileExpression.new(
            Ast::IntegerExpression.new(1), 
            [Ast::OperatorExpression.new("=", Ast::NameExpression.new("tmp"),Ast::NameExpression.new("a")), 
              Ast::CallSiteExpression.new("puts", [Ast::NameExpression.new("b")] )] )
    @parser = @parser.while_do
  end

  def test_big_while
    @string_input = <<HERE
while( n > 1) do
  tmp = a
  a = b
  b = tmp + b
  puts(b)
  n = n - 1
end
HERE
    @string_input.chop!
    @parse_output = {:while=>"while", 
      :while_cond=>{:l=>{:name=>"n"}, :o=>"> ", :r=>{:integer=>"1"}}, 
      :do=>"do", 
      :body=>{:expressions=>[{:l=>{:name=>"tmp"}, :o=>"= ", :r=>{:name=>"a"}}, 
                {:l=>{:name=>"a"}, :o=>"= ", :r=>{:name=>"b"}}, 
                {:l=>{:name=>"b"}, :o=>"= ", :r=>{:l=>{:name=>"tmp"}, :o=>"+ ", :r=>{:name=>"b"}}}, 
                {:call_site=>{:name=>"puts"}, 
                    :argument_list=>[{:argument=>{:name=>"b"}}]}, 
                {:l=>{:name=>"n"}, :o=>"= ", :r=>{:l=>{:name=>"n"}, :o=>"- ", :r=>{:integer=>"1"}}}], 
      :end=>"end"}}
    @transform_output = Ast::WhileExpression.new(
            Ast::OperatorExpression.new(">", Ast::NameExpression.new("n"),Ast::IntegerExpression.new(1)), 
            [Ast::OperatorExpression.new("=", Ast::NameExpression.new("tmp"),Ast::NameExpression.new("a")), 
             Ast::OperatorExpression.new("=", Ast::NameExpression.new("a"),Ast::NameExpression.new("b")), 
             Ast::OperatorExpression.new("=", Ast::NameExpression.new("b"),Ast::OperatorExpression.new("+", Ast::NameExpression.new("tmp"),
             Ast::NameExpression.new("b"))), Ast::CallSiteExpression.new("puts", [Ast::NameExpression.new("b")] ), 
             Ast::OperatorExpression.new("=", Ast::NameExpression.new("n"),Ast::OperatorExpression.new("-", Ast::NameExpression.new("n"),Ast::IntegerExpression.new(1)))] )
    @parser = @parser.while_do
  end
end