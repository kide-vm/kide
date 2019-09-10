require_relative "../helper"

module Risc
  class TestCollector < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
      Mom.boot!
      Risc.boot!
      @linker = Mom::MomCollection.new.to_risc.translate(:arm)
    end

    def test_simple_collect
      objects = Collector.collect_space(@linker)
      assert_equal 564 ,  objects.length , objects.length.to_s
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
    def test_integer_positions
      objects = Collector.collect_space(@linker)
      int = Parfait.object_space.get_next_for(:Integer)
      count = 0
      while(int)
        count += 1
        assert Position.set?(int) , "INT #{int.object_id.to_s(16)} , count #{count}"
        int = int.next_integer
      end
    end
  end
  class TestBigCollector < MiniTest::Test

    def setup
      opt = Parfait.default_test_options
      opt[:factory] = 400
      Parfait.boot!(opt)
      Mom.boot!
      Risc.boot!
      @linker = Mom::MomCollection.new.to_risc.translate(:arm)
    end

    def test_simple_collect
      objects = Collector.collect_space(@linker)
      assert_equal 564, objects.length , objects.length.to_s
    end

    def test_integer_positions
      objects = Collector.collect_space(@linker)
      int = Parfait.object_space.get_next_for(:Integer)
      count = 0
      while(int)
        count += 1
        assert Position.set?(int) , "INT #{int.object_id.to_s(16)} , count #{count}"
        int = int.next_integer
      end
    end

  end
end
