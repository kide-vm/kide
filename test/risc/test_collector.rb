require_relative "../helper"

module Risc
  class TestCollector < MiniTest::Test

    def setup
      @machine = Risc.machine.boot
    end

    def test_simple_collect
      objects = Risc::Collector.collect_space
      assert ((400 < objects.length) or (450 > objects.length)) , objects.length.to_s
    end

    def test_collect_all_types
      Risc::Collector.collect_space.each do |id, objekt|
        next unless objekt.is_a?( Parfait::Type )
        assert Parfait.object_space.get_type_for( objekt.hash ) , objekt.hash
      end
    end

    def test_allowed_types
      Risc::Collector.collect_space.each do |id, objekt|
        next if objekt.is_a?( Parfait::Object )
        next if objekt.is_a?( Symbol )
        assert_equal 1 , objekt.class
      end
    end
  end
end
