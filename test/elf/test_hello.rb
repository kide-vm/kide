require_relative "../helper"

class HelloTest < MiniTest::Test
  include AST::Sexp

  def check
    machine = Register.machine.boot
    Typed.compile( @input )
    machine.collect
    machine.translate_arm
    writer = Elf::ObjectWriter.new
    writer.save "hello.o"
  end

  def test_string_put
    @input = s(:statements, s(:class, :Object, s(:derives, nil), s(:statements, s(:function, :Integer, s(:name, :main), s(:parameters), s(:statements, s(:return, s(:call, s(:name, :putstring), s(:arguments), s(:receiver, s(:string, "Hello again\\n")))))))))
#FIXME: some more assembly tests need to get to the bottom of this one
#    check
  end
end
