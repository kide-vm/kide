require_relative "../helper"

class TestZeroCode < MiniTest::Test

  def test_string_put
    machine = Register.machine.boot
    space = Parfait.object_space
    space.each_type do | type |
      type.method_names.each do |method|
        type.remove_method(method)
      end
    end
    assert_equal 0 , space.collect_methods.length
    machine.collect_space
    machine.translate_arm
#    writer = Elf::ObjectWriter.new
#    writer.save "test/zero.o"
  end
end
