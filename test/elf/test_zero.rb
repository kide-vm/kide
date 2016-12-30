require_relative "../helper"

class TestZeroCode < MiniTest::Test

  def test_string_put
    machine = Register.machine.boot
    machine.collect
    machine.translate_arm
#    writer = Elf::ObjectWriter.new
#    writer.save "test/zero.o"
  end
end
