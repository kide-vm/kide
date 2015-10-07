module Phisol
  # collection of the simple ones, int and strings and such

  Compiler.class_eval do

    # Constant expressions can by definition be evaluated at compile time.
    # But that does not solve their storage, ie they need to be accessible at runtime from _somewhere_
    # So we view ConstantExpressions like functions that return the value of the constant.
    # In other words, their storage is the return slot as it would be for a method

    # The current approach moves the constant into a variable before using it
    # But in the future (in the one that holds great things) we optimize those unneccesay moves away

    def on_int expression
      int = expression.first
      to =  Virtual::Return.new(Virtual::Integer , int)
      @method.source.add_code Virtual::Set.new( int , to )
      to
    end

    def on_true expression
      to = Virtual::Return.new(Virtual::Reference , true )
      @method.source.add_code Virtual::Set.new( true , to )
      to
    end

    def on_false expression
      to = Virtual::Return.new(Virtual::Reference , false)
      @method.source.add_code Virtual::Set.new( false , to )
      to
    end

    def on_nil expression
      to = Virtual::Return.new(Virtual::Reference , nil)
      @method.source.add_code Virtual::Set.new( nil , to )
      to
    end

    def on_string expression
      # Clearly a TODO here to implement strings rather than reusing symbols
      value = expression.first.to_sym
      to = Virtual::Return.new(Virtual::Reference , value)
      @method.source.constants << value
      @method.source.add_code Virtual::Set.new( value , to )
      to
    end
  end
end
