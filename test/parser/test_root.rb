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
    @parse_output = [{:function_name=>{:name=>"foo"}, 
      :parmeter_list=>[{:parmeter=>{:name=>"x"}}], 
      :expressions=>[{:l=>{:name=>"a"}, :o=>"= ", :r=>{:integer=>"5"}}], :end=>"end"}, 
      {:call_site=>{:name=>"foo"}, :argument_list=>[{:argument=>{:integer=>"3"}}]}]
    @transform_output = [Ast::FunctionExpression.new(:foo, 
      [Ast::NameExpression.new("x")] , 
      [Ast::OperatorExpression.new("=", Ast::NameExpression.new("a"),Ast::IntegerExpression.new(5))] ), 
                        Ast::CallSiteExpression.new("foo", [Ast::IntegerExpression.new(3)] )]

  end

  def test_comments
    @string_input = <<HERE
def foo(x) #here
  a = 0           # a == r1
  b = 1           # b = r2
  while(n<1) do #comment
    tmp = a       # r3 <- r1
    a = b         # r1 <- r2
    b = tmp + b   #  r4 = r2 + r3  (r4 transient)  r2 <- r4 
    putstring(b)  
    n = n - 1     #me  
  end #no
end #anywhere
foo( 3 ) #and more
HERE
    @parse_output =[{:function_name=>{:name=>"foo"}, :parmeter_list=>[{:parmeter=>{:name=>"x"}}], :expressions=>[{:l=>{:name=>"a"}, :o=>"= ", :r=>{:integer=>"5"}}], :end=>"end"}, {:call_site=>{:name=>"foo"}, :argument_list=>[{:argument=>{:integer=>"3"}}]}]
    @transform_output = [Ast::FunctionExpression.new(:foo, [Ast::NameExpression.new("x")] , [Ast::OperatorExpression.new("=", Ast::NameExpression.new("a"),Ast::IntegerExpression.new(5))] ), Ast::CallSiteExpression.new(:foo, [Ast::IntegerExpression.new(3)] )]
  end

  def test_fibo1
    @string_input = <<HERE
def fibonaccit(n)
  a = 0 
  b = 1
  while( n > 1 ) do
    tmp = a
    a = b
    b = tmp + b
    puts(b)
    n = n - 1
  end
end

fibonaccit( 10 )
HERE
    @parse_output = [{:function_name=>{:name=>"fibonaccit"}, :parmeter_list=>[{:parmeter=>{:name=>"n"}}], :expressions=>[{:l=>{:name=>"a"}, :o=>"= ", :r=>{:integer=>"0"}}, {:l=>{:name=>"b"}, :o=>"= ", :r=>{:integer=>"1"}}, {:while=>"while", :while_cond=>{:l=>{:name=>"n"}, :o=>"> ", :r=>{:integer=>"1"}}, :do=>"do", :body=>{:expressions=>[{:l=>{:name=>"tmp"}, :o=>"= ", :r=>{:name=>"a"}}, {:l=>{:name=>"a"}, :o=>"= ", :r=>{:name=>"b"}}, {:l=>{:name=>"b"}, :o=>"= ", :r=>{:l=>{:name=>"tmp"}, :o=>"+ ", :r=>{:name=>"b"}}}, {:call_site=>{:name=>"puts"}, :argument_list=>[{:argument=>{:name=>"b"}}]}, {:l=>{:name=>"n"}, :o=>"= ", :r=>{:l=>{:name=>"n"}, :o=>"- ", :r=>{:integer=>"1"}}}], :end=>"end"}}], :end=>"end"}, {:call_site=>{:name=>"fibonaccit"}, :argument_list=>[{:argument=>{:integer=>"10"}}]}]
    @transform_output = [Ast::FunctionExpression.new(:fibonaccit, [Ast::NameExpression.new("n")] , [Ast::OperatorExpression.new("=", Ast::NameExpression.new("a"),Ast::IntegerExpression.new(0)),Ast::OperatorExpression.new("=", Ast::NameExpression.new("b"),Ast::IntegerExpression.new(1)),Ast::WhileExpression.new(Ast::OperatorExpression.new(">", Ast::NameExpression.new("n"),Ast::IntegerExpression.new(1)), [Ast::OperatorExpression.new("=", Ast::NameExpression.new("tmp"),Ast::NameExpression.new("a")), Ast::OperatorExpression.new("=", Ast::NameExpression.new("a"),Ast::NameExpression.new("b")), Ast::OperatorExpression.new("=", Ast::NameExpression.new("b"),Ast::OperatorExpression.new("+", Ast::NameExpression.new("tmp"),Ast::NameExpression.new("b"))), Ast::CallSiteExpression.new("puts", [Ast::NameExpression.new("b")] ), Ast::OperatorExpression.new("=", Ast::NameExpression.new("n"),Ast::OperatorExpression.new("-", Ast::NameExpression.new("n"),Ast::IntegerExpression.new(1)))] )] ), Ast::CallSiteExpression.new("fibonaccit", [Ast::IntegerExpression.new(10)] )]
  end
  
end


