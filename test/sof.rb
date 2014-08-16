require_relative "helper"
require "yaml"

class ObjectWithAttributes
  def initialize
    @name = "some name"
    @number = 1234
  end
end
OBJECT_STRING = "ObjectWithAttributes(name: 'some name', number: 1234)"

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
    assert_equal "#{OBJECT_STRING}" , out
  end
  def test_simple_array
    out = Sof::Writer.write([true, 1234])
    assert_equal "-true\n-1234" , out
  end
  def test_array_object
    out = Sof::Writer.write([true, 1234 , ObjectWithAttributes.new])
    assert_equal "-true\n-1234\n-#{OBJECT_STRING}" , out
  end
  def test_array_array
    out = Sof::Writer.write([true, 1 , [true , 12 ]])
    assert_equal "-true\n-1\n--true\n -12" , out
  end
  def test_array_array_reverse
    out = Sof::Writer.write([ [true , 12 ], true, 1])
    assert_equal "--true\n -12\n-true\n-1" , out
  end
  def test_array_array_array
    out = Sof::Writer.write([true, 1 , [true , 12 , [true , 123 ]]])
    assert_equal "-true\n-1\n--true\n -12\n --true\n  -123" , out
  end
  def test_array_array_object
    out = Sof::Writer.write([true, 1 , [true , 12 , ObjectWithAttributes.new]])
    assert_equal "-true\n-1\n--true\n -12\n -#{OBJECT_STRING}" , out
  end
  def test_simple_hash
    out = Sof::Writer.write({ one: 1 , tru: true })
    assert_equal "-:one: 1\n-:tru: true" , out
  end
  def test_hash_object
    out = Sof::Writer.write({ one: 1 , two: ObjectWithAttributes.new })
    assert_equal "-:one: 1\n-:two: #{OBJECT_STRING}" , out
  end
  def test_hash_array
    out = Sof::Writer.write({ one: [1 , ObjectWithAttributes.new] , two: true })
    assert_equal "-:one: -1\n -#{OBJECT_STRING}\n-:two: true" , out
  end
end