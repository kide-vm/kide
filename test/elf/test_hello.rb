require_relative "../helper"

class HelloTest < MiniTest::Test

  def check
    machine = Register.machine.boot
    Parfait::Space.object_space.get_class_by_name(:Integer).remove_instance_method :plus
    #TODO remove this hack: write proper aliases
    statements = machine.parse_and_compile @string_input
    output_at = "Register::CallImplementation"
    #{}"Register::CallImplementation"
    machine.collect
    machine.run_before output_at
    #puts Sof.write(machine.space)
    machine.run_after output_at
    writer = Elf::ObjectWriter.new(machine)
    writer.save "hello.o"
  end

  def pest_string_put
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
