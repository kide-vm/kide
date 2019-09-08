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
        class Class
          def get_name
            @name
          end
        end
        class Type
          def get_name
            @object_class.get_name
          end
        end
        class Space
          def main(arg)
            @type.get_name.putstring
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
      #assert_equal 4 , get_return , " "
      assert_equal "hi" , @interpreter.stdout
    end

  end
end
