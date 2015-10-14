require_relative "compiler_helper"

module Virtual
  class TestFunctions < MiniTest::Test
    include CompilerHelper

    def setup
      Virtual.machine.boot
    end

    #reset the compiler (other than other tests that need to fake their inside a method)
    def set_main compiler
      compiler.set_main(nil)
    end

    def test_puts
      @root = :function_definition
      @string_input    = <<HERE
int puts(ref str)
  main()
end
HERE
      @output = AST::Node
      check
    end
  end
end
