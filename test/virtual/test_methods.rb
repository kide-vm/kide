require_relative "virtual_helper"

class TestMethods < MiniTest::Test
  include VirtualHelper
  
  def test_simplest_function
    @string_input    = <<HERE
def foo(x) 
  5
end
HERE
    @output = [Virtual::MethodDefinition.new(:foo,[Virtual::Argument.new(:x,Virtual::Mystery.new())],Virtual::SelfReference.new(nil),Virtual::IntegerConstant.new(5),Virtual::MethodEnter.new(nil))]
    check
  end

  def test_class_function
    @string_input    = <<HERE
def String.length(x)
  @length
end
HERE
    @output = [Virtual::MethodDefinition.new(:length,[Virtual::Argument.new(:x,Virtual::Mystery.new())],Boot::BootClass.new(:String,:Object),Virtual::Return.new(Virtual::Mystery.new()),Virtual::MethodEnter.new(Virtual::ObjectGet.new(:length,nil)))]
    check
  end

  def test_function_ops
    @string_input    = <<HERE
def foo(x) 
 abba = 5 
 2 + 5
end
HERE
    @output = [Virtual::MethodDefinition.new(:foo,[Virtual::Argument.new(:x,Virtual::Mystery.new())],Virtual::SelfReference.new(nil),Virtual::Return.new(Virtual::Mystery),Virtual::MethodEnter.new(Virtual::FrameSet.new(:abba,Virtual::IntegerConstant.new(5),Virtual::LoadSelf.new(Virtual::IntegerConstant.new(2),Virtual::FrameSend.new(:+,[Virtual::IntegerConstant.new(5)],nil)))))]
    check
  end

  def test_function_ops_simple
    @string_input    = <<HERE
def foo()
  2 + 5
end
HERE
    @output = [Virtual::MethodDefinition.new(:foo,[],Virtual::SelfReference.new(nil),Virtual::Return.new(Virtual::Mystery),Virtual::MethodEnter.new(Virtual::LoadSelf.new(Virtual::IntegerConstant.new(2),Virtual::FrameSend.new(:+,[Virtual::IntegerConstant.new(5)],nil))))]
    check
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
      @output = [Virtual::MethodDefinition.new(:ofthen,[Virtual::Argument.new(:n,Virtual::Mystery.new())],Virtual::SelfReference.new(nil),Virtual::Local.new(:maybenot,Virtual::IntegerConstant.new(667)),Virtual::MethodEnter.new(Virtual::ImplicitBranch.new(:if_merge_1,Virtual::FrameSet.new(:isit,Virtual::IntegerConstant.new(42),Virtual::Label.new(:if_merge_1,nil)),Virtual::FrameSet.new(:maybenot,Virtual::IntegerConstant.new(667),Virtual::Label.new(:if_merge_1,nil)))))]
      check
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
    @output = [Virtual::MethodDefinition.new(:ofthen,[Virtual::Argument.new(:n,Virtual::Mystery.new())],Virtual::SelfReference.new(nil),Virtual::Local.new(:maybenot,Virtual::IntegerConstant.new(667)),Virtual::MethodEnter.new(Virtual::ImplicitBranch.new(:if_merge_2,Virtual::FrameSet.new(:isit,Virtual::IntegerConstant.new(42),Virtual::Label.new(:if_merge_2,nil)),Virtual::FrameSet.new(:maybenot,Virtual::IntegerConstant.new(667),Virtual::Label.new(:if_merge_2,nil)))))]
    check
  end

  def test_function_return
    @string_input    = <<HERE
def retvar(n)
  i = 5
  return i 
end
HERE
    @output = [Virtual::MethodDefinition.new(:retvar,[Virtual::Argument.new(:n,Virtual::Mystery.new())],Virtual::SelfReference.new(nil),Virtual::Reference.new(nil),Virtual::MethodEnter.new(Virtual::FrameSet.new(:i,Virtual::IntegerConstant.new(5),nil)))]
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
    @output = [Virtual::MethodDefinition.new(:foo,[Ast::NameExpression.new(:x)])]
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
    @output = [Virtual::MethodDefinition.new(:foo,[Ast::NameExpression.new(:x)])]
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
    @output = [Virtual::MethodDefinition.new(:foo,[Ast::NameExpression.new(:x)])]
    check
  end  
end