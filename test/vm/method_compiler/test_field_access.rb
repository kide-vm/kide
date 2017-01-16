require_relative "helper"

module Register
  class TestFields < MiniTest::Test
    include ExpressionHelper
    include AST::Sexp

    def setup
      Register.machine.boot
    end

    def test_field_not_defined
      @root = :field_access
      @input = s(:field_access, s(:receiver, s(:known, :self)), s(:field, s(:ivar, :a)))
      assert_raises(RuntimeError) { check }
    end

    def test_field_not_space
      @root = :field_access
      @input = s(:field_access, s(:receiver, s(:known, :self)), s(:field, s(:ivar, :space)))

      assert_raises(RuntimeError) { check }
    end

    def test_field
      add_space_field(:bro,:Object)
      @root = :field_access
      @input = s(:field_access,s(:receiver, s(:known, :self)),s(:field,s(:ivar, :bro)))
      @output = Register::RegisterValue
      check
    end

  end
end
