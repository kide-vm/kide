require_relative "../helper"

class HelloTest < MiniTest::Test

  def check
    machine = Register.machine.boot
    machine.parse_and_compile @string_input
    machine.collect
    machine.translate_arm
    writer = Elf::ObjectWriter.new(machine)
    writer.save "hello.o"
  end

  def test_string_put
    @string_input    = <<HERE
class Object
  int main()
    "Hello again\n".putstring()
  end
end
HERE
    check
  end
end
