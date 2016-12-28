module Typed
  # collection of the simple ones, int and strings and such

  module BasicValues

    # Constant expressions can by definition be evaluated at compile time.
    # But that does not solve their storage, ie they need to be accessible at runtime from _somewhere_
    # So expressions move the data into a Register.
    # All expressions return registers

    # But in the future (in the one that holds great things) we optimize those unneccesay moves away

    def on_IntegerExpression expression
      int = expression.value
      reg = use_reg :Integer , int
      add_code Register.load_constant( expression, int , reg )
      return reg
    end

    def on_TrueExpression expression
      reg = use_reg :Boolean
      add_code Register.load_constant( expression, true , reg )
      return reg
    end

    def on_FalseExpression expression
      reg = use_reg :Boolean
      add_code Register.load_constant( expression, false , reg )
      return reg
    end

    def on_NilExpression expression
      reg = use_reg :NilClass
      add_code Register.load_constant( expression, nil , reg )
      return reg
    end

    def on_StringExpression expression
      value = Parfait.new_word expression.value.to_sym
      reg = use_reg :Word
      Register.machine.constants << value
      add_code Register.load_constant( expression, value , reg )
      return reg
    end

    def on_ClassExpression expression
      name = expression.value
      clazz = Parfait::Space.object_space.get_class_by_name! name
      raise "No such class #{name}" unless clazz
      reg = use_reg :MetaClass , clazz
      add_code Register.load_constant( expression, clazz , reg )
      return reg
    end

  end
end
