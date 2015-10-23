module Soml
  # collection of the simple ones, int and strings and such

  Compiler.class_eval do

    # Constant statements can by definition be evaluated at compile time.
    # But that does not solve their storage, ie they need to be accessible at runtime from _somewhere_
    # So we view ConstantExpressions like functions that return the value of the constant.
    # In other words, their storage is the return slot as it would be for a method

    # The current approach moves the constant into a variable before using it
    # But in the future (in the one that holds great things) we optimize those unneccesay moves away

    def on_int statement
      int = statement.first
      reg = use_reg :Integer , int
      add_code Register::LoadConstant.new( statement, int , reg )
      return reg
    end

    def on_true statement
      reg = use_reg :Boolean
      add_code Register::LoadConstant.new( statement, true , reg )
      return reg
    end

    def on_false statement
      reg = use_reg :Boolean
      add_code Register::LoadConstant.new( statement, false , reg )
      return reg
    end

    def on_nil statement
      reg = use_reg :NilClass
      add_code Register::LoadConstant.new( statement, nil , reg )
      return reg
    end

    def on_string statement
      value = statement.first.to_sym
      reg = use_reg :Word
      @method.source.constants << value
      add_code Register::LoadConstant.new( statement, value , reg )
      return reg
    end
  end
end
