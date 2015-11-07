require_relative 'helper'

class TestObject < MiniTest::Test
  include RuntimeTests

  def test_main
    @string_input =  "return 1"
    check
  end

  def test_get_layout
    @string_input =  "return get_layout()"
    check
  end



end
