require_relative 'helper'

module Register
class TestBasicClass < MiniTest::Test
  include Fragments

  def test_class_def
    @string_input = <<HERE
class Bar
  int buh()
    return 1
  end
end
class Object
  int main()
    return 1
  end
end
HERE
    @length = 17
    check
  end
end
end
