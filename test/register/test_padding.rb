require_relative "../helper"

class TestPadding < MiniTest::Test

  def test_small
    [6,27,28].each do |p|
      assert_equal 32 , Padding.padded(p) , "Expecting 32 for #{p}"
    end
  end
  def test_medium
    [29,33,40,57,60].each do |p|
      assert_equal 64 , Padding.padded(p) , "Expecting 64 for #{p}"
    end
  end
  def test_large
    [61,65,88].each do |p|
      assert_equal 96 , Padding.padded(p) , "Expecting 96 for #{p}"
    end
  end
end
