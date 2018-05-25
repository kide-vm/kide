require_relative "../helper"

class TestZeroCode < MiniTest::Test

  def setup
    @machine = Risc.machine.boot
    @space = Parfait.object_space
    @space.each_type do | type |
      type.method_names.each do |method|
        type.remove_method(method) unless keeper(method)
      end
    end
    @objects = Risc::Collector.collect_space
  end
  def keeper name
    name == :main or name == :__init__
  end

  def pest_empty_translate
    assert_equal 2 , @space.get_all_methods.length
    @machine.translate(:arm)
    writer = Elf::ObjectWriter.new(@machine , @objects )
    writer.save "test/zero.o"
  end

  def test_methods_match_objects
    assert_equal 2 , @space.get_all_methods.length
    @objects.each do |id , objekt|
      next unless objekt.is_a? Parfait::TypedMethod
      assert keeper(objekt.name) ,  "CODE1 #{objekt.name}"
    end
  end
end
