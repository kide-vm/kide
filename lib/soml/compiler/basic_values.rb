module Soml
  # collection of the simple ones, int and strings and such

  Compiler.class_eval do

    # Constant expressions can by definition be evaluated at compile time.
    # But that does not solve their storage, ie they need to be accessible at runtime from _somewhere_
    # So expressions move the data into a Register.
    # All expressions return registers

    # But in the future (in the one that holds great things) we optimize those unneccesay moves away

    def on_int expression
      int = expression.first
      reg = use_reg :Integer , int
      add_code Register::LoadConstant.new( expression, int , reg )
      return reg
    end

    def on_true expression
      reg = use_reg :Boolean
      add_code Register::LoadConstant.new( expression, true , reg )
      return reg
    end

    def on_false expression
      reg = use_reg :Boolean
      add_code Register::LoadConstant.new( expression, false , reg )
      return reg
    end

    def on_nil expression
      reg = use_reg :NilClass
      add_code Register::LoadConstant.new( expression, nil , reg )
      return reg
    end

    def on_string expression
      value = expression.first.to_sym
      reg = use_reg :Word
      @method.source.constants << value
      add_code Register::LoadConstant.new( expression, value , reg )
      return reg
    end

    def on_class_name expression
      name = expression.first
      clazz = Parfait::Space.object_space.get_class_by_name! name
      raise "No such class #{name}" unless clazz
      reg = use_reg :Class , clazz
      add_code Register::LoadConstant.new( expression, clazz , reg )
      return reg
    end

  end
end
