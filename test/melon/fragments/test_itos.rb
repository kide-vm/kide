require_relative 'helper'

module Melon
  class TestRubyItos < MiniTest::Test
    include MelonTests

    def pest_ruby_itos
      @string_input = <<HERE
  100000.to_s
HERE
      @stdout = "Hello there"
      check
    end

  end
end
