require_relative "compiler_helper"

module Virtual
  class TestFields < MiniTest::Test
    include CompilerHelper

    def setup
      Virtual.machine.boot
    end

    def test_call_main_plain
      @root = :call_site
      @string_input    = <<HERE
main()
HERE
      @output = Register::RegisterValue
      check
    end

    def test_call_main_int
      @root = :call_site
      @string_input    = <<HERE
main(1)
HERE
      @output = Register::RegisterValue
      check
    end

    def test_call_main_string
      @root = :call_site
      @string_input    = <<HERE
main("1")
HERE
      @output = Register::RegisterValue
      check
    end

    def ttest_call_main_op
      Virtual.machine.space.get_main.ensure_local(:bar , :int)
      @root = :call_site
      @string_input    = <<HERE
main( bar )
HERE
      @output = Register::RegisterValue
      check
    end
  end
end
