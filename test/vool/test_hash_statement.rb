require_relative "../helper"

module Vool
  class HashArray < MiniTest::Test

    def test_empty
      lst = Compiler.compile( "{}")
      assert_equal HashStatement , lst.class
    end
    def test_empty_length
      lst = Compiler.compile( "{}")
      assert_equal 0 , lst.length
    end
    def test_one
      lst = Compiler.compile( "{ 1 => 2}")
      assert_equal HashStatement , lst.class
    end
    def test_one_length
      lst = Compiler.compile( "{ 1 => 2}")
      assert_equal 1 , lst.length
    end
    def test_one_pair
      lst = Compiler.compile( "{ 1 => 2}")
      assert_equal 1 , lst.hash.keys.first.value
    end
    def test_two_length
      lst = Compiler.compile( "{ sym: :works , 'string_too' => 2}")
      assert_equal 2 , lst.length
    end
    def test_two_key_one
      lst = Compiler.compile( "{ sym: :works , 'string_too' => 2}")
      assert_equal :sym , lst.hash.keys.first.value
    end
  end
end
