require_relative 'helper'

class TestLayoutRT < MiniTest::Test
  include RuntimeTests

  def test_main
    @string_input =  "return 1"
    check_return 1
  end

  def test_get_layout
    @string_input =  "return get_layout()"
    check_return_class Parfait::Layout

  end

  def test_get_class
    @string_input =  "return get_class()"
    check_return_class Parfait::Layout
  end



end
