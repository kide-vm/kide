require_relative "../helper"

module Risc
  class InterpreterSetters < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.div4"
      @string_input = <<MAIN
      class Space
        def self.get
          @inst = 5
          return @inst
        end
        def main(arg)
          return Space.get
        end
      end
MAIN
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      run_input @string_input
      assert_equal 5 , get_return
    end

  end
end
