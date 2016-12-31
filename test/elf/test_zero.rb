require_relative "../helper"

class TestZeroCode < MiniTest::Test

  def setup
    @machine = Register.machine.boot
    @space = Parfait.object_space
    @space.each_type do | type |
      type.method_names.each do |method|
        type.remove_method(method) unless keeper(method)
      end
    end
    @machine.collect_space
  end
  def keeper name
    name == :main or name == :__init__
  end

  def test_empty_translate
    assert_equal 2 , @space.collect_methods.length
    @machine.translate_arm
    writer = Elf::ObjectWriter.new
    writer.save "test/zero.o"
  end

  def test_methods_match_objects
    assert_equal 2 , @space.collect_methods.length
    @machine.objects.each do |id , objekt|
      next unless objekt.is_a? Parfait::TypedMethod
      assert keeper(objekt.name) ,  "CODE1 #{objekt.name}"
    end
  end
end
