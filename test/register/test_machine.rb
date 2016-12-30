require_relative "../helper"

module Register
  class TestMachine < MiniTest::Test

    def setup
      @machine = Register.machine.boot
    end

    def test_collect_all_types
      @machine.collect_space
      @machine.objects.each do |id, objekt|
        next unless objekt.is_a?( Parfait::Type )
        assert Parfait.object_space.get_type_for( objekt.hash ) , objekt.hash
      end
    end
  end
end
