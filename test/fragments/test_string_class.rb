require_relative 'helper'

class TestStringClass < MiniTest::Test
  include Fragments

  def test_string_class
    @string_input = <<HERE
class Object
  int raise()
    self.putstring()
    self.exit()
  end
  int method_missing(ref name,ref args)
    name.raise()
  end
  ref class()
    ref l = self.layout
    l = l.object_class()
    return l
  end
  ref resolve_method(ref name)
    ref clazz = self.class()
    ref function = clazz._get_instance_variable(name)
    int index = clazz.index_of(name)
    if( function == nil )
      name.raise()
    else
      return function
    end
  end
  int index_of( ref name )
    ref l = self.layout
    return l.index_of(name)
  end
  ref old_layout()
    return self.layout
  end
end
class Class
  int Class.new_object( int length )
    return 4
  end
end
class String

  ref self.new_string(int len )
    len =  len << 2
    return super.new_object( len)
  end

  int length()
    return self.length
  end

  int plus(ref str)
    my_length = self.length
    str_len = str.length()
    my_length = str_len + my_length
    new_string = self.new_string(my_length )
    i = 0
    while( i < my_length)
      char = get(i)
      new_string.set(i , char)
      i = i + 1
    end
    i = 0
    while( i < str_len)
      char = str.get(i)
      len = i + my_length
      new_string.set(  len , char)
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
