require_relative "compiler_helper"
require_relative "code_checker"

module Virtual
  class TestFoo < MiniTest::Test
    include CodeChecker

    def test_foo2
      @string_input = <<HERE
int a
int foo(int x)
  int b = self.a
  return b +x
end
HERE
      @expect =  [ Virtual::Return ]
      check
    end


  end
end
