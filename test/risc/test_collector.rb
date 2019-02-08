require_relative "../helper"

module Risc
  class TestCollector < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
      Risc.boot!
      @linker = Mom::MomCompiler.new.translate(:arm)
    end

    def test_simple_collect
      objects = Collector.collect_space(@linker)
      assert ((400 < objects.length) or (450 > objects.length)) , objects.length.to_s
    end

    def test_collect_all_types
      Collector.collect_space(@linker).each do |objekt , position|
        next unless objekt.is_a?( Parfait::Type )
        assert Parfait.object_space.get_type_for( objekt.hash ) , objekt.hash
      end
    end

    def test_allowed_types
      Collector.collect_space(@linker).each do |objekt , position|
        next if objekt.is_a?( Parfait::Object )
        next if objekt.is_a?( Symbol )
        assert false
      end
    end
    def test_positions
      Collector.collect_space(@linker).each do |objekt , position|
        assert_equal Position , position.class
        assert !position.valid?
      end
    end
  end
end
