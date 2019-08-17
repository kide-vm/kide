require_relative "helper"

module Parfait
  class TestPadding < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
    end

    def test_small
      [6,27,28].each do |p|
        assert_equal 32 , Parfait::Object.padded(p) , "Expecting 32 for #{p}"
      end
    end
    def test_medium
      [29,33,40,57,60].each do |p|
        assert_equal 64 , Parfait::Object.padded(p) , "Expecting 64 for #{p}"
      end
    end

    def test_large
      [61,65,88].each do |p|
        assert_equal 96 , Parfait::Object.padded(p) , "Expecting 96 for #{p}"
      end
    end
    def test_list1
      list = Parfait.new_list([1])
      assert_equal 32 , list.padded_length
    end
    def test_list5
      list = Parfait.new_list([1,2,3,4,5])
      assert_equal 64 , list.padded_length
    end
    def test_type
      type = Parfait::Type.for_hash Parfait.object_space.get_class_by_name(:Object) , {}
      type.set_type( type )
      assert_equal 32 , type.padded_length
    end
    def test_word
      word = Parfait::Word.new(12)
      assert_equal 32 , word.padded_length
    end

  end
end
