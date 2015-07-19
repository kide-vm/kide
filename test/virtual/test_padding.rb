require_relative "../helper"

class Padded
  include Padding
end

class TestPadding < MiniTest::Test

  def setup
    @pad = Padded.new
  end
  def test_small
    [6,20,23,24].each do |p|
      assert_equal 32 , @pad.padded(p) , "Expecting 32 for #{p}"
    end
  end
  def test_medium
    [26,40,53,56].each do |p|
      assert_equal 64 , @pad.padded(p) , "Expecting 64 for #{p}"
    end
  end
  def test_large
    [58,88].each do |p|
      assert_equal 96 , @pad.padded(p) , "Expecting 96 for #{p}"
    end
  end
end
