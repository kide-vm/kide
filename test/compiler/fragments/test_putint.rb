require_relative 'helper'

class TestPutint < MiniTest::Test
  include Fragments

  def test_putint
    @string_input = <<HERE
class Integer
  int putint()
    return 1
  end
end
class Object
  int main()
    42.putint()
  end
end
HERE
    @length = 33
    check
  end
end
