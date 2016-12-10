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
      @input = s(:field_access, s(:receiver, s(:name, :self)), s(:field, s(:name, :a)))
      assert_raises(RuntimeError) { check }
    end

    def test_field_not_space
      @root = :field_access
      @input = s(:field_access,
  s(:receiver,
    s(:name, :self)),
  s(:field,
    s(:name, :space)))

      assert_raises(RuntimeError) { check }
    end

    def test_field
      add_object_field(:bro,:Object)
      @root = :field_access
      @input = s(:field_access,  s(:receiver, s(:name, :self)),  s(:field,    s(:name, :bro)))
      @output = Register::RegisterValue
      check
    end

  end
end
