require_relative 'helper'

class TestLayoutRT < MiniTest::Test
  include ParfaitTests

  def test_main
    @main =  "return 1"
    check_return 1
  end

  def check_return_class val
  end

  def test_get_layout
    @main =  "return get_layout()"
    check
    assert_equal  Parfait::Layout , @interpreter.get_register(:r0).return_value.class
  end

  def test_get_class
    @main =  "return get_class()"
    check
    assert_equal  Parfait::Layout , @interpreter.get_register(:r0).return_value.class
  end

  def test_puts_class
    @main = <<HERE
Class c = get_class()
Word w = c.get_name()
w.putstring()
HERE
    @stdout = "Space"
    check
  end


end
