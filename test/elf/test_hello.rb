require_relative "../helper"

class HelloTest < MiniTest::Test
  include AST::Sexp

  def check
    machine = Risc.machine.boot
    Vm.compile_ast( @input )
    objects = Risc::Collector.collect_space
    machine.translate_arm
    writer = Elf::ObjectWriter.new(machine , objects )
    writer.save "test/hello.o"
  end

  def test_string_put
    @input = s(:statements, s(:return, s(:call, :putstring, s(:arguments),
                  s(:receiver, s(:string, "Hello again\\n")))))
    check
  end
end
