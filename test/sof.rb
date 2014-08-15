require_relative "helper"

class ObjectWithAttributes
  def initialize
    @name = "some object"
    @number = 1234
  end
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
  def test_object
    out = Sof::Writer.write(ObjectWithAttributes.new)
    assert_equal "ObjectWithAttributes(name: 'some object' ,number: 1234)\n" , out
  end
  def test_simple_array
    out = Sof::Writer.write([true, 1234])
    assert_equal "-true\n-1234\n" , out    
  end
  def test_array_object
    out = Sof::Writer.write([true, 1234 , ObjectWithAttributes.new])
    assert_equal "-true\n-1234\n-ObjectWithAttributes(name: 'some object' ,number: 1234)\n\n" , out    
  end
  def test_array_array
    out = Sof::Writer.write([true, 1 , [true , 12 ]])
    assert_equal "-true\n-1\n--true\n -12\n\n" , out    
  end
  def test_array_array_array
    out = Sof::Writer.write([true, 1 , [true , 12 , [true , 123 ]]])
    assert_equal "-true\n-1\n--true\n -12\n --true\n  -123\n\n\n" , out    
  end
  def ttest_array_array_object
    out = Sof::Writer.write([true, 1 , [true , 12 , ObjectWithAttributes.new]])
#    puts out
    assert_equal "-true\n-1234\n--true\n -12\n\n" , out    
  end

end