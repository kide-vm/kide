require_relative '../helper'

module Mains
  class MainsTest < MiniTest::Test
    include Risc::Ticker
    def setup;end

    def run_main_check(input , stdout , exit_code)
      run_main(input)
      assert_equal stdout , @interpreter.stdout , "Wrong stdout"
      assert_equal exit_code , get_return.to_s , "Wrong exit code"
    end
  end
end
