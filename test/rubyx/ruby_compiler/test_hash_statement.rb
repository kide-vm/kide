require_relative "helper"

module Vool
  class HashArrayX < MiniTest::Test
    include RubyTests

    def test_empty
      lst = compile( "{}")
      assert_equal HashStatement , lst.class
    end
    def test_empty_length
      lst = compile( "{}")
      assert_equal 0 , lst.length
    end
    def test_one
      lst = compile( "{ 1 => 2}")
      assert_equal HashStatement , lst.class
    end
    def test_one_length
      lst = compile( "{ 1 => 2}")
      assert_equal 1 , lst.length
    end
    def test_one_pair
      lst = compile( "{ 1 => 2}")
      assert_equal 1 , lst.hash.keys.first.value
    end
    def test_two_length
      lst = compile( "{ sym: :works , 'string_too' => 2}")
      assert_equal 2 , lst.length
    end
    def test_two_key_one
      lst = compile( "{ sym: :works , 'string_too' => 2}")
      assert_equal :sym , lst.hash.keys.first.value
    end
  end
end
