require_relative "helper"

module Register
  class TestCall < MiniTest::Test
    include ExpressionHelper
    include AST::Sexp

    def setup
      Register.machine.boot
      @output = Register::RegisterValue
    end

    def test_call_main_plain
      @input    = s(:call,s(:name, :main),s(:arguments))
      check
    end

    def test_call_main_int
      Register.machine.space.get_main.add_argument(:blar , :Integer)
      @input    =s(:call,s(:name, :main),s(:arguments , s(:int, 1)))
      check
    end

    def test_call_main_string
      Register.machine.space.get_main.add_argument(:blar , :Word)
      @input    =s(:call,s(:name, :main),s(:arguments , s(:string, "1") ))
      check
    end

    def test_call_main_op
      Register.machine.space.get_main.add_local(:bar , :Integer)
      Register.machine.space.get_main.add_argument(:blar , :Integer)
      @input    =s(:call,s(:name, :main),s(:arguments , s(:name, :bar) ))
      check
    end

    def test_call_string_put
      @input    = s(:call,s(:name, :putstring),s(:arguments),s(:receiver,s(:string, "Hello Raisa, I am salama")))
      check
    end

  end
end
