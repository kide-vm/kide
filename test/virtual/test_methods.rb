require_relative "virtual_helper"

class TestFunctionDefinition < MiniTest::Test
  include VirtualHelper
  
  def test_simplest_function
    @string_input    = <<HERE
def foo(x) 
  5
end
HERE
    @output = [Virtual::Method.new(:foo,[Ast::NameExpression.new(:x)],Virtual::SelfReference.new(),Virtual::Integer,Virtual::MethodEnter.new(nil))]
    check
  end

  def test_class_function
    @string_input    = <<HERE
def String.length(x)
  @length
end
HERE
    @output = [Virtual::Method.new(:length,[Ast::NameExpression.new(:x)],Boot::BootClass.new(:String,:Object),Virtual::Reference,Virtual::MethodEnter.new(nil))]
    check
  end

  def test_function_ops
    @string_input    = <<HERE
def foo(x) 
 abba = 5 
 2 + 5
end
HERE
    @output = [Virtual::Method.new(:foo,[Ast::NameExpression.new(:x)],Virtual::SelfReference.new(),Virtual::Reference,Virtual::MethodEnter.new(Virtual::FrameSet.new(:abba,Virtual::IntegerConstant.new(5))))]
    check
  end

  def ttest_function_if
    @string_input    = <<HERE
def ofthen(n)
  if(0)
    isit = 42
  else
    maybenot = 667
  end
end
HERE
      @output = [Virtual::Method.new(:foo,[Ast::NameExpression.new(:x)])]
      check
  end

  def ttest_function_return
    @string_input    = <<HERE
def retvar(n)
  i = 5
  return i 
end
HERE
    @output = [Virtual::Method.new(:foo,[Ast::NameExpression.new(:x)])]
    check
  end

  def ttest_function_return_if
    @string_input    = <<HERE
def retvar(n)
  if( n > 5)
    return 10
  else
    return 20
  end 
end
HERE
    @output = [Virtual::Method.new(:foo,[Ast::NameExpression.new(:x)])]
    check
  end

  def ttest_function_return_while
    @string_input    = <<HERE
def retvar(n)
  while( n > 5) do
    n = n + 1
    return n
  end 
end
HERE
    @output = [Virtual::Method.new(:foo,[Ast::NameExpression.new(:x)])]
    check
  end

  def ttest_function_while
    @string_input    = <<HERE
def fibonaccit(n)
  a = 0
  while (n) do
    some = 43
    other = some * 4
  end
end
HERE
    @output = [Virtual::Method.new(:foo,[Ast::NameExpression.new(:x)])]
    check
  end

  def ttest_function_big_while
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
    @output = [Virtual::Method.new(:foo,[Ast::NameExpression.new(:x)])]
    check
  end  
end