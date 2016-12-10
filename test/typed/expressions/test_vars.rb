require_relative "helper"

module Register
  class TestFields < MiniTest::Test
    include ExpressionHelper
    include AST::Sexp

    def setup
      Register.machine.boot
    end

    def test_local
      Register.machine.space.get_main.ensure_local(:bar , :Integer)
      @input    = s(:name, :bar)
      @output = Register::RegisterValue
      check
    end

    def test_space
      @root = :name
      @input    = s(:name, :space)
      @output = Register::RegisterValue
      check
    end

    def test_args
      Register.machine.space.get_main.arguments.push Parfait::Variable.new(:Integer , :bar)
      @input    = s(:name, :bar)
      @output = Register::RegisterValue
      check
    end

  end
end
