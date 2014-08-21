require_relative "virtual_helper"

class HelloTest < MiniTest::Test
  include VirtualHelper
  
  def check
    machine = Virtual::Machine.boot
    expressions = machine.compile_main @string_input
    puts ""
    puts Sof::Writer.write(expressions)
    Virtual::Object.space.run_passes
    puts ""
    puts Sof::Writer.write(expressions)
  end

  def test_simplest_function
    @string_input    = <<HERE
def foo(x) 
  5
end
HERE
    check
  end

  def test_puts_string
    @string_input    = <<HERE
def foo()
  puts("Hello")
end
foo()
HERE
    check
  end
end