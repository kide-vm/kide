require_relative "helper"

class TestRoot < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
    
  def test_double_root
    @string_input = <<HERE
def foo(x) 
  a = 5
end

foo( 3 )
HERE
    @parse_output = [
          {:function_definition=> {  :name=>"foo"}, :parmeter_list => [ {:parmeter=>{:name=>"x"}} ] , 
                      :expressions=>[{:asignee=>{:name=>"a"}, :asigned=>{:integer=>"5"} } ] } , 
          {:function_call => { :name => "foo" }, :argument_list => [ { :argument => { :integer => "3" } } ] }]
    @transform_output = [ Ast::FunctionExpression.new("foo"    , 
                                [Ast::NameExpression.new("x")] , 
                                [Ast::AssignmentExpression.new( "a", Ast::IntegerExpression.new(5)) ] ) ,
                          Ast::FuncallExpression.new( "foo", [ Ast::IntegerExpression.new(3) ] ) ]

  end
  
end


