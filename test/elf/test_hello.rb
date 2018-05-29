require_relative "../helper"

class HelloTest < MiniTest::Test

  def setup
    Risc.machine
  end
  def check
    Vool::VoolCompiler.ruby_to_binary( "class Space;def main(arg);#{@input};end;end" )
    writer = Elf::ObjectWriter.new(Risc.machine)
    writer.save "test/hello.o"
  end

  def test_string_put
    @input = "return 'Hello'.putstring"
    check
  end
end
