require_relative "compiler_helper"

module Virtual
  class TestCall < MiniTest::Test
    include CompilerHelper

    def setup
      Virtual.machine.boot
    end

    def test_call_main_plain
      @root = :call_site
      @string_input    = 'main()'
      @output = Register::RegisterValue
      check
    end

    def test_call_main_int
      @root = :call_site
      @string_input    =  'main(1)'
      @output = Register::RegisterValue
      check
    end

    def ttest_call_self_main
      @root = :call_site
      @string_input    =  'self.main()'
      @output = Register::RegisterValue
      check
    end

    def test_call_main_string
      @root = :call_site
      @string_input    = 'main("1")'
      @output = Register::RegisterValue
      check
    end

    def ttest_call_main_op
      Virtual.machine.space.get_main.ensure_local(:bar , :Integer)
      @root = :call_site
      @string_input    = 'main( bar )'
      @output = Register::RegisterValue
      check
    end

    def test_call_string_put
      @root = :call_site
      @string_input    = '"Hello Raisa, I am salama".putstring()'
      @output = Register::RegisterValue
      check
    end

  end
end
