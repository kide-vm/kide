require_relative 'helper'

class TestRubyLoop < MiniTest::Test
  include MelonTests

  def test_ruby_loop
    @string_input = <<HERE
counter = 100000
while(counter > 0) do
  counter -=  1
end
HERE
    @stdout = "Hello there"
    check
  end

end
