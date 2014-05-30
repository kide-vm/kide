require_relative "helper"

class TestClassDef < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
  
  def test_simplest_class
    @string_input    = <<HERE
class foo
  5
end
HERE
    @parse_output = {:name=>"foo", :class_expressions=>[{:integer=>"5"}], :end=>"end"}
    @transform_output = Ast::ClassExpression.new("foo" ,[Ast::IntegerExpression.new(5)] )
    @parser = @parser.class_definition
  end

  def test_class_ops
    @string_input    = <<HERE
class ops
  def foo(x)
    abba = 5 
    2 + 5
  end
end
HERE
    @parse_output = {:name=>"ops", :class_expressions=>[{:function_name=>{:name=>"foo"}, :parmeter_list=>[{:parmeter=>{:name=>"x"}}], :expressions=>[{:l=>{:name=>"abba"}, :o=>"= ", :r=>{:integer=>"5"}}, {:l=>{:integer=>"2"}, :o=>"+ ", :r=>{:integer=>"5"}}], :end=>"end"}], :end=>"end"}
    @transform_output = Ast::ClassExpression.new("ops" ,[Ast::FunctionExpression.new(:foo, [Ast::NameExpression.new("x")] , [Ast::OperatorExpression.new("=", Ast::NameExpression.new("abba"),Ast::IntegerExpression.new(5)),Ast::OperatorExpression.new("+", Ast::IntegerExpression.new(2),Ast::IntegerExpression.new(5))] )] )
    @parser = @parser.class_definition
  end

  def test_class_if
    @string_input    = <<HERE
class sif
  def ofthen(n)
    if(0)
      isit = 42
    else
      maybenot = 667
    end
  end
end
HERE
    @parse_output = {:name=>"sif", :class_expressions=>[{:function_name=>{:name=>"ofthen"}, :parmeter_list=>[{:parmeter=>{:name=>"n"}}], :expressions=>[{:if=>"if", :conditional=>{:integer=>"0"}, :if_true=>{:expressions=>[{:l=>{:name=>"isit"}, :o=>"= ", :r=>{:integer=>"42"}}], :else=>"else"}, :if_false=>{:expressions=>[{:l=>{:name=>"maybenot"}, :o=>"= ", :r=>{:integer=>"667"}}], :end=>"end"}}], :end=>"end"}], :end=>"end"}
    @transform_output = Ast::ClassExpression.new("sif" ,[Ast::FunctionExpression.new(:ofthen, [Ast::NameExpression.new("n")] , [Ast::IfExpression.new(Ast::IntegerExpression.new(0), [Ast::OperatorExpression.new("=", Ast::NameExpression.new("isit"),Ast::IntegerExpression.new(42))],[Ast::OperatorExpression.new("=", Ast::NameExpression.new("maybenot"),Ast::IntegerExpression.new(667))] )] )] )
    @parser = @parser.class_definition
  end

  def test_class_function
    @string_input    = <<HERE
class sif
  ofthen(3+4 , var)
  def ofthen(n,m)
    44
  end
end
HERE
    @parse_output = {:name=>"sif", :class_expressions=>[{:call_site=>{:name=>"ofthen"}, :argument_list=>[{:argument=>{:l=>{:integer=>"3"}, :o=>"+", :r=>{:integer=>"4"}}}, {:argument=>{:name=>"var"}}]}, {:function_name=>{:name=>"ofthen"}, :parmeter_list=>[{:parmeter=>{:name=>"n"}}, {:parmeter=>{:name=>"m"}}], :expressions=>[{:integer=>"44"}], :end=>"end"}], :end=>"end"}
    @transform_output = Ast::ClassExpression.new(:sif ,[Ast::CallSiteExpression.new(:ofthen, [Ast::OperatorExpression.new("+", Ast::IntegerExpression.new(3),Ast::IntegerExpression.new(4)),Ast::NameExpression.new("var")] ), Ast::FunctionExpression.new(:ofthen, [Ast::NameExpression.new("n"),Ast::NameExpression.new("m")] , [Ast::IntegerExpression.new(44)] )] )
    @parser = @parser.class_definition
  end
  def test_class_module
    @string_input    = <<HERE
class foo
  module bar
    funcall(3+4 , var)
  end
end
HERE
    @parse_output = {:name=>"foo", :class_expressions=>[{:name=>"bar", :module_expressions=>[{:call_site=>{:name=>"funcall"}, :argument_list=>[{:argument=>{:l=>{:integer=>"3"}, :o=>"+", :r=>{:integer=>"4"}}}, {:argument=>{:name=>"var"}}]}], :end=>"end"}], :end=>"end"}
    @transform_output = Ast::ClassExpression.new(:foo ,[Ast::ModuleExpression.new(:bar ,[Ast::CallSiteExpression.new(:funcall, [Ast::OperatorExpression.new("+", Ast::IntegerExpression.new(3),Ast::IntegerExpression.new(4)),Ast::NameExpression.new("var")] )] )] )
    @parser = @parser.class_definition
  end
end