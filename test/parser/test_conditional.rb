require_relative "helper"

class TestConditional < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
    
  def test_conditional
    @string_input = <<HERE
if(0) 
  42
else
  667
end
HERE
    @parse_output = { :conditional => { :integer => "0"}, 
                  :if_true => {  :expressions => [ { :integer => "42" } ] } , 
                  :if_false => { :expressions => [ { :integer => "667" } ] } }
    @transform_output = Ast::ConditionalExpression.new(  Ast::IntegerExpression.new(0),
                  [Ast::IntegerExpression.new(42)], [Ast::IntegerExpression.new(667)])

    @parser = @parser.conditional
  end

  def test_while
    @string_input = <<HERE
while 1 do
  tmp = a
  a = b
end
HERE
#go in there
#  b = tmp + b
#  puts(b)
#  n = n - 1

    @parse_output = {:while=>"while", :while_cond=>{:integer=>"1"}, :do=>"do", :body=>{:expressions=>[{:asignee=>{:name=>"tmp"}, :asigned=>{:name=>"a"}}, {:asignee=>{:name=>"a"}, :asigned=>{:name=>"b"}}]}}
    @transform_output = Ast::WhileExpression.new(
                  Ast::IntegerExpression.new(1), 
                  [Ast::AssignmentExpression.new("tmp", Ast::NameExpression.new("a")), Ast::AssignmentExpression.new("a", Ast::NameExpression.new("b"))] )
    @parser = @parser.while
  end
end