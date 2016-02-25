require_relative 'helper'

class TestTypeRT < MiniTest::Test
  include ParfaitTests

  def test_main
    @main =  "return 1"
    check 1
  end

  def check_return_class val
  end

  def test_get_type
    @main =  "return get_type()"
    interpreter = check
    assert_equal  Parfait::Type , interpreter.get_register(:r0).return_value.class
  end

  def test_get_class
    @main =  "return get_class()"
    interpreter = check
    assert_equal  Parfait::Class , interpreter.get_register(:r0).return_value.class
  end

  def test_puts_class
    @main = <<HERE
Word w = get_class_name()
w.putstring()
HERE
    @stdout = "Space"
    check
  end

  def test_puts_type_space
    @main = <<HERE
Type l = get_type()
Word w = l.get_class_name()
w.putstring()
HERE
    @stdout = "Type"
    check
  end

  # copy of register parfait tests, in order
  def test_message_type
    @main = <<HERE
Message m = self.first_message
m = m.next_message
Word w = m.get_class_name()
w.putstring()
HERE
    @stdout = "Message"
    check
  end


end
