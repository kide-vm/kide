require_relative "../helper"

module Risc
  class InterpreterClassSend < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.div4"
      @string_input = <<MAIN
      class Space
        def self.get
          return 5
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
