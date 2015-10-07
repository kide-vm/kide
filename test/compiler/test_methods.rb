require_relative "compiler_helper"
require_relative "code_checker"

module Virtual
  class TestMethods < MiniTest::Test
    include CodeChecker

    def test_module
      @string_input    = <<HERE
class Some
  int foo()
    return 5
  end
end
HERE
      @output = [[MethodEnter] ,[MethodReturn]]
      check
    end

    def test_simplest_function
      @string_input    = <<HERE
class Object
  int foo(int x)
    return x
  end
end
HERE
      @output = [[MethodEnter] ,[MethodReturn]]
      check
    end

  def test_second_simplest_function
    @string_input    = <<HERE
class Object
  ref foo(ref x)
    return x
  end
end
HERE
    @output = [[Virtual::MethodEnter],[Virtual::MethodReturn]]
    check
  end

  def test_puts_string
    @string_input    = <<HERE
class Object
  int puts(ref str)
    return str
  end
  int main()
    puts("Hello")
  end
end
HERE
    @output = [[MethodEnter ,  NewMessage, Set, Set , Set, Set, MethodCall],[MethodReturn]]
    check
  end

  def test_int_function
    @string_input    = <<HERE
class Integer < Object
int times(int x)
  self * x
end
end
HERE
    @output = [[Virtual::MethodEnter] , [Virtual::MethodReturn]]
    check
    cla = Virtual.machine.space.get_class_by_name :Integer
    assert cla.get_instance_method( :times )
  end

  def ttest_function_ops
    @string_input    = <<HERE
def foo(x)
 abba = 5
 2 + 5
end
HERE
    @output = nil
    check
  end

  def ttest_function_ops_simple
    @string_input    = <<HERE
def foo()
  2 + 5
end
HERE
    @output = [[Virtual::MethodEnter],[Virtual::MethodReturn]]
    check
  end

  def ttest_ops_simple
    #TODO ops still botched
    @string_input    = <<HERE
2 + 5
HERE
    @output = [[Virtual::MethodEnter , Virtual::Set,Virtual::NewMessage,Virtual::Set,
        Virtual::Set ,Virtual::Set,Virtual::Set,Virtual::MessageSend] , [Virtual::MethodReturn]]
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
    @output = nil
    check
  end

  def test_while
    @string_input    = <<HERE
class Object
  int foo()
    while(1)
      3
    end
  end
end
HERE
    @output = [[Virtual::MethodEnter],[Virtual::MethodReturn]]
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
    @output = nil
    check
  end

  def pest_function_return
    @string_input    = <<HERE
def retvar(n)
  i = 5
  return i
end
HERE
    @output = ""
    check
  end

  def pest_function_return_if
    @string_input    = <<HERE
def retvar(n)
  if( n > 5)
    return 10
  else
    return 20
  end
end
HERE
    @output = ""
    check
  end

  def est_function_return_while
    @string_input    = <<HERE
def retvar(n)
  while( n > 5) do
    n = n + 1
    return n
  end
end
HERE
    @output = ""
    check
  end

  def pest_function_big_while
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
    @output = ""
    check
  end
end
end
