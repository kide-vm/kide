require_relative "virtual_helper"

class TestMethods < MiniTest::Test
  include VirtualHelper
#TODO need to rethink this approach
# Sof working as well as it is will serialize the whole space as everythink is reachable from a
#  method. Even ignoring the size and readability issues, it make sthe test to fragile:
#   any small object change anywhere in parfait will cause a different output
  def ttest_simplest_function
    @string_input    = <<HERE
def foo(x)
  5
end
HERE
    @output = nil
    check
  end

  def ttest_puts_string
    @string_input    = <<HERE
def foo()
  puts("Hello")
end
foo()
HERE
    @output = nil
    check
  end

  def ttest_class_function
    @string_input    = <<HERE
def String.length(x)
  @length
end
HERE
    @output = nil
    check
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
    @output = nil
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
