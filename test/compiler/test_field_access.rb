require_relative "compiler_helper"
require_relative "code_checker"

module Virtual
  class TestFoo < MiniTest::Test
    include CodeChecker

    def test_foo3
      @string_input = <<HERE
field int a
int foo(int x)
  int b = self.a
  return b +x
end
HERE
      @output =  [ [Virtual::MethodEnter] , [Virtual::MethodReturn] ]
      check
    end


  end
end
