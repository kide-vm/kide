require_relative "helper"

module Parfait
  class TestInteger < ParfaitTest

    def setup
      super
      @int = Integer.new(10)
    end

    def test_class
      assert_equal :Integer, @int.get_type.object_class.name
    end
    def test_next_nil
      assert_nil @int.next_integer
    end
    def test_next_not_nil
      int2 = Integer.new(0 , @int)
      assert_equal Integer,  int2.next_integer.class
    end
    def test_value_10
      assert_equal 10 , @int.value
    end
    def test_word_value_10
      assert_equal 10 , @int.get_internal_word( Integer.integer_index )
    end
    def test_word_settable
      assert_equal 20 , @int.set_internal_word( Integer.integer_index , 20 )
    end
    def test_word_set
      assert_equal 20 , @int.set_internal_word( Integer.integer_index , 20 )
      assert_equal 20 , @int.get_internal_word( Integer.integer_index )
    end
    def test_integer_first
      assert Parfait.object_space.next_integer
    end
    def test_integer_20
      int = Parfait.object_space.next_integer
      20.times do
        assert int
        assert_equal Parfait::Integer , int.class
        assert int.get_internal_word(1)
        int = int.next_integer
      end
    end
    def test_set
      @int.set_value(1)
      assert_equal 1 , @int.value
    end
  end
end
