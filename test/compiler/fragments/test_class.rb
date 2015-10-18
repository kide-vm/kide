require_relative 'helper'

class TestBasicClass < MiniTest::Test
  include Fragments

  def test_class_basic
    @string_input = <<HERE
class Bar
  int buh()
    return 1
  end
end
HERE
    @expect =  [ [SaveReturn] ,[RegisterTransfer,GetSlot,FunctionReturn]]
    check
  end


end
