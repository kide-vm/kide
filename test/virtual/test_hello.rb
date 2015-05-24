require_relative "virtual_helper"

class HelloTest < MiniTest::Test
  include VirtualHelper

  def check
    machine = Virtual::Machine.boot
    expressions = machine.compile_main @string_input

    writer = Elf::ObjectWriter.new(machine)
    writer.save "hello.o"
#    puts Sof::Writer.write(expressions)
    puts Sof::Writer.write(machine.space)
  end

  def qtest_simplest_function
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
  putstring("Hello")
end
foo()
HERE
    check
  end

  def ttest_string_put
    @string_input    = <<HERE
def foo()
  "Hello".puts()
end
HERE
    check
  end
end
