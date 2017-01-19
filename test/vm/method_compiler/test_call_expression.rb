require_relative "helper"

module Risc
  class TestCall < MiniTest::Test
    include ExpressionHelper
    include AST::Sexp

    def setup
      Risc.machine.boot
      @output = Risc::RiscValue
    end

    def test_call_main_plain
      @input    = s(:call , :main ,s(:arguments))
      check
    end

    def test_call_main_int
      Parfait.object_space.get_main.add_argument(:blar , :Integer)
      @input    =s(:call, :main ,s(:arguments , s(:int, 1)))
      check
    end

    def test_call_main_string
      Parfait.object_space.get_main.add_argument(:blar , :Word)
      @input    =s(:call, :main ,s(:arguments , s(:string, "1") ))
      check
    end

    def test_call_main_op
      Parfait.object_space.get_main.add_local(:bar , :Integer)
      Parfait.object_space.get_main.add_argument(:blar , :Integer)
      @input    =s(:call, :main ,s(:arguments , s(:local, :bar) ))
      check
    end

    def test_call_string_put
      @input    = s(:call, :putstring,s(:arguments),s(:receiver,s(:string, "Hello Raisa, I am salama")))
      check
    end

  end
end
