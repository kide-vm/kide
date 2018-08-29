require_relative "helper"

module Parfait
  class TestFactory < ParfaitTest

    def setup
      super
      @factory = Factory.new Parfait.object_space.get_type_by_class_name(:Integer)
    end
    def test_ok
      assert @factory
    end
    def test_name_ok
      assert @factory.attribute_name.to_s.start_with?("next")
    end
    def test_get_next
      assert_nil @factory.get_next_for( Integer.new(1))
    end
    def test_no_next
      assert_nil @factory.next_object
      assert_nil @factory.reserve
    end
    def test_get_next_object
      assert_equal Parfait::Integer ,  @factory.get_next_object.class
    end
    def test_first_is_reserve
      @factory.get_next_object
      assert_equal Parfait::Integer , @factory.reserve.class
    end
    def test_chain_length
      count = 0
      start = @factory.get_next_object
      while( start )
        start = start.next_integer
        count += 1
      end
      assert_equal 1024 - 10 , count
    end
    def test_reserve_length
      count = 0
      start = @factory.get_next_object
      start = @factory.reserve
      while( start )
        start = start.next_integer
        count += 1
      end
      assert_equal 11 , count
    end
  end
end
