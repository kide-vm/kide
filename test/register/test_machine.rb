require_relative "../helper"

module Register
  class TestMachine < MiniTest::Test

    def setup
      @machine = Register.machine.boot
    end

    def test_collect_all_types
      objects = Register::Collector.collect_space
      objects.each do |id, objekt|
        next unless objekt.is_a?( Parfait::Type )
        assert Parfait.object_space.get_type_for( objekt.hash ) , objekt.hash
      end
    end
  end
end
