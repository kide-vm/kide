require_relative "helper"

module Register
  class TestCall < MiniTest::Test
    include ExpressionHelper

    def setup
      Register.machine.boot
      @output = Register::RegisterValue
    end

    def test_call_main_plain
      @input    = 'main()'
      check
    end

    def test_call_main_int
      @input    =  'main(1)'
      check
    end

    def test_call_main_string
      @input    = 'main("1")'
      check
    end

    def test_call_main_op
      Register.machine.space.get_main.ensure_local(:bar , :Integer)
      @input    = 'main( bar )'
      check
    end

    def test_call_string_put
      @input    = '"Hello Raisa, I am salama".putstring()'
      check
    end

  end
end
