require_relative "helper"

class SimpleObjectWithAttributes
end

class BasicSof < MiniTest::Test

  def test_true
    out = Sof::Members.write(true)
    assert_equal  " true\n" , out
  end
  def test_num
    out = Sof::Members.write(124)
    assert_equal  " 124\n" , out
  end

end