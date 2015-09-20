require_relative "compiler_helper"
module Virtual
  class TestMethods < MiniTest::Test

    def check
      Virtual.machine.boot.compile_main @string_input
      produced = Virtual.machine.space.get_main.source
      assert @output , "No output given"
      assert_equal @output.length ,  produced.blocks.length , "Block length"
      produced.blocks.each_with_index do |b,i|
        codes = @output[i]
        assert codes , "No codes for block #{i}"
        assert_equal b.codes.length , codes.length , "Code length for block #{i}"
        b.codes.each_with_index do |c , ii |
          assert_equal codes[ii] ,  c.class ,  "Block #{i} , code #{ii}"
        end
      end
    end

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
int foo(int x)
  return x
end
HERE
      @output = [[MethodEnter] ,[MethodReturn]]
      check
    end

  def test_second_simplest_function
    @string_input    = <<HERE
ref foo(ref x)
  return x
end
HERE
    @output = [[Virtual::MethodEnter],[Virtual::MethodReturn]]
    check
  end

  def test_puts_string
    @string_input    = <<HERE
int foo()
  puts("Hello")
end
foo()
HERE
    @output = [[Virtual::MethodEnter ,  Virtual::NewMessage, Virtual::Set, Virtual::Set, Virtual::MessageSend],
                [Virtual::MethodReturn]]
    check
  end

  def ttest_class_function
    @string_input    = <<HERE
int self.length(int x)
  self.length
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
while(1)
  3
end
HERE
    @output = [[MethodEnter],[Set,IsTrueBranch,Set,UnconditionalBranch],[],[MethodReturn]]
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
