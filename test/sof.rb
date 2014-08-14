require_relative "helper"

class SimpleObjectWithAttributes
end

class BasicSof < MiniTest::Test

  def test_true
    out = Sof::Writer.write(true)
    assert_equal  "true" , out
  end
  def test_num
    out = Sof::Writer.write(124)
    assert_equal  "124" , out
  end

end