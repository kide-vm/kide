require_relative 'helper'

class TestStringClass < MiniTest::Test
  include Fragments

  def test_string_class
    @string_input = <<HERE
class Object
  def raise()
    putstring()
    exit()
  end
  def method_missing(name,args)
    name.raise()
  end
  def class()
    l = @layout
    return l.class()
  end
  def resolve_method(name)
    clazz = class()
    function = clazz._get_instance_variable(name)
    index = clazz.index_of(name)
    if( function == 0 )
      name.raise()
    else
      return function
    end
  end
  def index_of( name )
    l = @layout
    return l.index_of(name)
  end
  def old_layout()
    return @layout
  end
end
class Class
  def Class.new_object( length )
    return 4
  end
end
class String
  def String.new_string( len )
    return Class.new_object( len << 2 )
  end
  def length()
    return @length
  end
  def plus(str)
    my_length = @length
    str_len = str.length()
    new_string = String.new_string(my_length + str_len)
    i = 0
    while( i < my_length) do
      char = get(i)
      new_string.set(i , char)
      i = i + 1
    end
    i = 0
    while( i < str_len) do
      char = str.get(i)
      new_string.set( i + my_length , char)
      i = i + 1
    end
    return new_string
  end
end
HERE
  @expect =  [Virtual::Return ]
  check
  end

end
