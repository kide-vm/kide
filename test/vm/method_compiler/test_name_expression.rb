require_relative "helper"

module Risc
  class TestFields < MiniTest::Test
    include ExpressionHelper
    include AST::Sexp

    def setup
      Risc.machine.boot
    end

    def test_local
      Parfait.object_space.get_main.add_local(:bar , :Integer)
      @input    = s(:local, :bar)
      @output = Risc::RiscValue
      check
    end

    def test_space
      @root = :name
      @input    = s(:known, :space)
      @output = Risc::RiscValue
      check
    end

    def test_args
      Parfait.object_space.get_main.add_argument(:bar , :Integer)
      @input    = s(:arg, :bar)
      @output = Risc::RiscValue
      check
    end

  end
end
