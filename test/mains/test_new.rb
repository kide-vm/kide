require_relative 'helper'

# The "New" in this TestNew means that this is the place to develop a new test for the
# mains dir.
# If you just pop a file in the source directory, all tests will run.
# This is fine if all is fine. But if all is fine, you are not developing, just playing.
# So when you really need to itereate editing this gives guard auto-run and just of that
# one test that you work on.

# After getting the test to run, copy paste the whole code into a file in source and revert
# changes on this file.

module Mains
  class TestNew < MiniTest::Test
    include Risc::Ticker

    def whole_input
      <<-eos
        class Space
          def times
            n = 5
            i = 0
            while( i < 5 )
              yield
              i = i + 1
            end
            return 1
          end
          def main(arg)
            times{
              "1".putstring
            }
            return 4
          end
        end
      eos
    end

    def setup
      @string_input = whole_input
      super
    end
    def test_chain
      run_all
      assert_equal ::Integer , get_return.class , " "
      assert_equal 4 , get_return , " "
      assert_equal "hi" , @interpreter.stdout
    end

  end
end
