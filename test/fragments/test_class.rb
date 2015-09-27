require_relative 'helper'

class TestBasicClass < MiniTest::Test
  include Fragments

  def test_class_basic
    @string_input = <<HERE
module Foo
  class Bar
    int buh()
      return 1
    end
  end
end
HERE
    @expect =  [ Virtual::Return ]
    check
  end


end
