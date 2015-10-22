require_relative "compiler_helper"

module Register
  class TestCall < MiniTest::Test
    include CompilerHelper

    def setup
      Register.machine.boot
      @root = :call_site
      @output = Register::RegisterValue
    end

    def test_call_main_plain
      @string_input    = 'main()'
      check
    end

    def test_call_main_int
      @string_input    =  'main(1)'
      check
    end

    def test_call_self_main
      @string_input    =  'self.main()'
      check
    end

    def test_call_main_string
      @string_input    = 'main("1")'
      check
    end

    def test_call_main_op
      Register.machine.space.get_main.ensure_local(:bar , :Integer)
      @string_input    = 'main( bar )'
      check
    end

    def test_call_string_put
      @string_input    = '"Hello Raisa, I am salama".putstring()'
      check
    end

  end
end
