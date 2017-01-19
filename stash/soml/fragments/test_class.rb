require_relative 'helper'

module Risc
class TestBasicClass < MiniTest::Test
  include Fragments

  def test_class_def
    @string_input = <<HERE
class Bar
  int buh()
    return 1
  end
end
class Space
  int main()
    return 1
  end
end
HERE
    @length = 15
    check
  end
end
end
