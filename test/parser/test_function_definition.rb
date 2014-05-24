require_relative "helper"

class TestFunctionDefinition < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
  
  def test_simplest_function
    @string_input    = <<HERE
def foo(x) 
  5
end
HERE
    @parse_output ={:function_name=>{:name=>"foo"}, 
    :parmeter_list=>[{:parmeter=>{:name=>"x"}}], :expressions=>[{:integer=>"5"}], :end=>"end"}
    @transform_output = Ast::FunctionExpression.new('foo', 
                [Ast::NameExpression.new('x')], 
                [Ast::IntegerExpression.new(5)])
    @parser = @parser.function_definition
  end

  def test_function_ops
    @string_input    = <<HERE
def foo(x) 
 abba = 5 
 2 + 5
end
HERE
    @parse_output = {:function_name=>{:name=>"foo"}, 
    :parmeter_list=>[{:parmeter=>{:name=>"x"}}], 
    :expressions=>[{:l=>{:name=>"abba"}, :o=>"= ", :r=>{:integer=>"5"}}, 
      {:l=>{:integer=>"2"}, :o=>"+ ", :r=>{:integer=>"5"}}], :end=>"end"}
    @transform_output = Ast::FunctionExpression.new(:foo, 
      [Ast::NameExpression.new("x")] , 
      [Ast::OperatorExpression.new("=", Ast::NameExpression.new("abba"),Ast::IntegerExpression.new(5)),
        Ast::OperatorExpression.new("+", Ast::IntegerExpression.new(2),Ast::IntegerExpression.new(5))] )
    @parser = @parser.function_definition
  end

  def test_function_if
    @string_input    = <<HERE
def ofthen(n)
  if(0)
    isit = 42
  else
    maybenot = 667
  end
end
HERE
    @parse_output = {:function_name=>{:name=>"ofthen"}, 
    :parmeter_list=>[{:parmeter=>{:name=>"n"}}], 
    :expressions=>[{:if=>"if", :conditional=>{:integer=>"0"}, 
    :if_true=>{:expressions=>[{:l=>{:name=>"isit"}, :o=>"= ", :r=>{:integer=>"42"}}], :else=>"else"}, 
    :if_false=>{:expressions=>[{:l=>{:name=>"maybenot"}, :o=>"= ", :r=>{:integer=>"667"}}], :end=>"end"}}], 
    :end=>"end"}
    @transform_output = Ast::FunctionExpression.new(:ofthen, 
          [Ast::NameExpression.new("n")] , 
          [Ast::IfExpression.new(Ast::IntegerExpression.new(0), 
            [Ast::OperatorExpression.new("=", Ast::NameExpression.new("isit"),
              Ast::IntegerExpression.new(42))],
          [Ast::OperatorExpression.new("=", Ast::NameExpression.new("maybenot"),Ast::IntegerExpression.new(667))] )] )
    @parser = @parser.function_definition
  end

  def test_function_while
    @string_input    = <<HERE
def fibonaccit(n)
  a = 0
  while (n) do
    some = 43
    other = some * 4
  end
end
HERE
    @parse_output ={:function_name=>{:name=>"fibonaccit"}, 
              :parmeter_list=>[{:parmeter=>{:name=>"n"}}], 
              :expressions=>[{:l=>{:name=>"a"}, :o=>"= ", :r=>{:integer=>"0"}}, 
                {:while=>"while", :while_cond=>{:name=>"n"}, :do=>"do", 
                    :body=>{:expressions=>[{:l=>{:name=>"some"}, :o=>"= ", :r=>{:integer=>"43"}},
                           {:l=>{:name=>"other"}, :o=>"= ", :r=>{:l=>{:name=>"some"}, :o=>"* ", :r=>{:integer=>"4"}}}], 
                :end=>"end"}}], 
              :end=>"end"}
    @transform_output = Ast::FunctionExpression.new(:fibonaccit, 
          [Ast::NameExpression.new("n")] , 
          [Ast::OperatorExpression.new("=", Ast::NameExpression.new("a"),Ast::IntegerExpression.new(0)),
            Ast::WhileExpression.new(Ast::NameExpression.new("n"), 
              [Ast::OperatorExpression.new("=", Ast::NameExpression.new("some"),Ast::IntegerExpression.new(43)), 
                Ast::OperatorExpression.new("=", Ast::NameExpression.new("other"),Ast::OperatorExpression.new("*", Ast::NameExpression.new("some"),Ast::IntegerExpression.new(4)))] )] )
    @parser = @parser.function_definition
  end

  def test_function_big_while
    @string_input    = <<HERE
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
HERE
    @parse_output = {:function_name=>{:name=>"fibonaccit"}, :parmeter_list=>[{:parmeter=>{:name=>"n"}}], :expressions=>[{:l=>{:name=>"a"}, :o=>"= ", :r=>{:integer=>"0"}}, {:l=>{:name=>"b"}, :o=>"= ", :r=>{:integer=>"1"}}, {:while=>"while", :while_cond=>{:l=>{:name=>"n"}, :o=>"> ", :r=>{:integer=>"1"}}, :do=>"do", :body=>{:expressions=>[{:l=>{:name=>"tmp"}, :o=>"= ", :r=>{:name=>"a"}}, {:l=>{:name=>"a"}, :o=>"= ", :r=>{:name=>"b"}}, {:l=>{:name=>"b"}, :o=>"= ", :r=>{:l=>{:name=>"tmp"}, :o=>"+ ", :r=>{:name=>"b"}}}, {:call_site=>{:name=>"puts"}, :argument_list=>[{:argument=>{:name=>"b"}}]}, {:l=>{:name=>"n"}, :o=>"= ", :r=>{:l=>{:name=>"n"}, :o=>"- ", :r=>{:integer=>"1"}}}], :end=>"end"}}], :end=>"end"}
    @transform_output = Ast::FunctionExpression.new(:fibonaccit, [Ast::NameExpression.new("n")] , [Ast::OperatorExpression.new("=", Ast::NameExpression.new("a"),Ast::IntegerExpression.new(0)),Ast::OperatorExpression.new("=", Ast::NameExpression.new("b"),Ast::IntegerExpression.new(1)),Ast::WhileExpression.new(Ast::OperatorExpression.new(">", Ast::NameExpression.new("n"),Ast::IntegerExpression.new(1)), [Ast::OperatorExpression.new("=", Ast::NameExpression.new("tmp"),Ast::NameExpression.new("a")), Ast::OperatorExpression.new("=", Ast::NameExpression.new("a"),Ast::NameExpression.new("b")), Ast::OperatorExpression.new("=", Ast::NameExpression.new("b"),Ast::OperatorExpression.new("+", Ast::NameExpression.new("tmp"),Ast::NameExpression.new("b"))), Ast::CallSiteExpression.new("puts", [Ast::NameExpression.new("b")] ), Ast::OperatorExpression.new("=", Ast::NameExpression.new("n"),Ast::OperatorExpression.new("-", Ast::NameExpression.new("n"),Ast::IntegerExpression.new(1)))] )] )
    @parser = @parser.function_definition
  end  
end