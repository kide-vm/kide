require_relative "compiler_helper"
require_relative "code_checker"

module Virtual
  class TestMethods < MiniTest::Test
    include CodeChecker

    def test_simplest_function
      @string_input    = <<HERE
class Object
  int main()
    return 5
  end
end
HERE
      @output = [[MethodEnter,Set] ,[MethodReturn]]
      check
    end


    def test_second_simplest_function
      @string_input    = <<HERE
class Object
  int main()
    int x = 5
    return x
  end
end
HERE
      @output = [[Virtual::MethodEnter,Set],[Virtual::MethodReturn]]
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

    def test_function_ops
      @string_input    = <<HERE
class Object
  int foo(int abba)
   abba = 5
   2 + 5
  end
end
HERE
      @output = [[Virtual::MethodEnter] , [Virtual::MethodReturn]]
      check
    end

    def test_function_if
      @string_input    = <<HERE
class Object
  int main()
    if(0)
      return 42
    else
      return 667
    end
  end
end
HERE
      @output = [[MethodEnter,Set,Register::IsZeroBranch] , [Set,Register::AlwaysBranch],
                  [Set],[],[MethodReturn]]
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

    def test_function_while
      @string_input    = <<HERE
class Object
  int fibonaccit(int n)
    int a = 0
    while(n)
      int some = 43
      int other = some * 4
    end
  end
end
HERE
      @output = [[Virtual::MethodEnter],[Virtual::MethodReturn]]
      check
    end

    def test_function_return
      @string_input    = <<HERE
class Object
  int retvar(int n)
    int i = 5
    return i
  end
end
HERE
      @output = [[Virtual::MethodEnter],[Virtual::MethodReturn]]
      check
    end

    def test_function_return_if
      @string_input    = <<HERE
class Object
  int main()
    int n = 10
    if( n > 5)
      return 10
    else
      return 20
    end
  end
end
HERE
      @output = [[MethodEnter,Set,Set,Register::GetSlot,Register::GetSlot,
                  Register::OperatorInstruction,Register::IsZeroBranch],
                  [Set,Register::AlwaysBranch],[Set],[],[MethodReturn]]
      check
    end

    def test_function_return_while
      @string_input    = <<HERE
class Object
  int main()
    int n = 10
    while( n > 5)
      n = n + 1
      return n
    end
  end
end
HERE
      @output = [[MethodEnter,Set],
                 [Set,Register::GetSlot,Register::GetSlot,Register::OperatorInstruction,
                   Register::IsZeroBranch,Set,Register::GetSlot,Register::GetSlot,
                   Register::OperatorInstruction,Set,Register::AlwaysBranch] ,
                   [],[MethodReturn]]
      check
    end
  end
end
