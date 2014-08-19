require_relative "helper"
require "yaml"

class ObjectWithAttributes
  def initialize
    @name = "some name"
    @number = 1234
  end
  attr_accessor :extra
end
OBJECT_STRING = "ObjectWithAttributes(:name => 'some name', :number => 1234)"

class BasicSof < MiniTest::Test
  def check should
    same = (should == @out)
    puts "Shouldda\n#{@out}" unless same
    assert_equal should , @out
  end
  def test_true
    @out = Sof::Writer.write(true)
    check "true" 
  end
  def test_num
    @out = Sof::Writer.write(124)
    check  "124" 
  end
  def test_simple_object
    @out = Sof::Writer.write(ObjectWithAttributes.new)
    check "#{OBJECT_STRING}" 
  end
  def test_object_extra_array
    object = ObjectWithAttributes.new
    object.extra = [:sym , 123]
    @out = Sof::Writer.write(object)
    check "#{OBJECT_STRING}\n :extra [:sym, 123]" 
  end
  def test_simple_array
    @out = Sof::Writer.write([true, 1234])
    check "[true, 1234]" 
  end
  def test_array_object
    @out = Sof::Writer.write([true, 1234 , ObjectWithAttributes.new])
    check "-true\n-1234\n-#{OBJECT_STRING}" 
  end
  def test_array_array
    @out = Sof::Writer.write([true, 1 , [true , 12 ]])
    check "-true\n-1\n-[true, 12]" 
  end
  def test_array_array_reverse
    @out = Sof::Writer.write([ [true , 12 ], true, 1])
    check "-[true, 12]\n-true\n-1" 
  end
  def test_array_array_array
    @out = Sof::Writer.write([true, 1 , [true , 12 , [true , 123 ]]])
    check "-true\n-1\n--true\n -12\n -[true, 123]" 
  end
  def test_array_array_object
    @out = Sof::Writer.write([true, 1 , [true , 12 , ObjectWithAttributes.new]])
    check "-true\n-1\n--true\n -12\n -#{OBJECT_STRING}" 
  end
  def test_simple_hash
    @out = Sof::Writer.write({ one: 1 , tru: true })
    check "-:one => 1\n-:tru => true" 
  end
  def test_hash_object
    @out = Sof::Writer.write({ one: 1 , two: ObjectWithAttributes.new })
    check "-:one => 1\n-:two => #{OBJECT_STRING}" 
  end
  def test_array_hash
    @out = Sof::Writer.write([true, 1 , { one: 1 , tru: true }])
    check "-true\n-1\n--:one => 1\n -:tru => true" 
  end
  def test_hash_array
    @out = Sof::Writer.write({ one: [1 , ObjectWithAttributes.new] , two: true })
    check "-:one => -1\n -#{OBJECT_STRING}\n-:two => true" 
  end
  def test_array_recursive
    ar = [true, 1 ]
    ar << ar
    @out = Sof::Writer.write(ar)
    check "&1 [true, 1, *1]" 
  end
  def test_object_recursive
    object = ObjectWithAttributes.new
    object.extra = object
    @out = Sof::Writer.write(object)
    check "&1 ObjectWithAttributes(:name => 'some name', :number => 1234, :extra => *1)" 
  end
  def test_object_inline
    object = ObjectWithAttributes.new
    object.extra = Object.new
    @out = Sof::Writer.write(object)
    check "ObjectWithAttributes(:name => 'some name', :number => 1234, :extra => Object())" 
  end
  def test_class
    @out = Sof::Writer.write(ObjectWithAttributes)
    check "ObjectWithAttributes"
  end
end