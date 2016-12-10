require_relative "helper"

module Register
  class TestOps < MiniTest::Test
    include ExpressionHelper
    include AST::Sexp

    def setup
      Register.machine.boot
      @root = :operator_value
      @output = Register::RegisterValue
    end

    def operators
      [:+ , :- , :* , :/ , :== ]
    end
    def test_ints
      operators.each do |op|
        @input = s(:operator_value, op , s(:int, 2), s(:int, 3))
        check
      end
    end
    def test_local_int
      Register.machine.space.get_main.ensure_local(:bar , :Integer)
      @input    = s(:operator_value, :+, s(:name, :bar), s(:int, 3))
      check
    end
    def test_int_local
      Register.machine.space.get_main.ensure_local(:bar , :Integer)
      @input    = s(:operator_value, :+, s(:int, 3), s(:name, :bar))
      check
    end

    def test_field_int
      add_object_field(:bro,:int)
      @input = s(:operator_value, :+, s(:field_access,  s(:receiver, s(:name, :self)),
                                                        s(:field, s(:name, :bro))),
                                      s(:int, 3))
      check
    end

    def test_int_field
      add_object_field(:bro,:int)
      @input = s(:operator_value, :+, s(:int, 3), s(:field_access, s(:receiver, s(:name, :self)),
                                                  s(:field,s(:name, :bro))))
      check
    end
  end
end
