require_relative 'helper'

class TestRubyHello < MiniTest::Test
  include MelonTests

  def test_ruby_hello
    @string_input = <<HERE
  puts "Hello there"
HERE
    @stdout = "Hello there"
    check
  end

  def pest_ruby_hello_looping
    @string_input = <<HERE
  counter = 100000;
  while(counter > 0) do
  puts "Hello there"
  STDOUT.flush
  counter = counter - 1
  end
HERE
    @length = 37
    @stdout = "Hello Raisa, I am salama"
    check
  end
end
