module Bosl
  # collection of the simple ones, int and strings and such

  Compiler.class_eval do

    # Constant expressions can by definition be evaluated at compile time.
    # But that does not solve their storage, ie they need to be accessible at runtime from _somewhere_
    # So we view ConstantExpressions like functions that return the value of the constant.
    # In other words, their storage is the return slot as it would be for a method

    # The current approach moves the constant into a variable before using it
    # But in the future (in the one that holds great things) we optimize those unneccesay moves away

  #    attr_reader :value
      def on_int expression
        int = expression.first
        to =  Virtual::Return.new(Virtual::Integer , int)
        method.source.add_code Virtual::Set.new( int , to )
        to
      end

      def on_true expression
        to = Virtual::Return.new(Virtual::Reference , true )
        method.source.add_code Virtual::Set.new( true , to )
        to
      end

      def on_false expression
        to = Virtual::Return.new(Virtual::Reference , false)
        method.source.add_code Virtual::Set.new( false , to )
        to
      end

      def on_nil expression
        to = Virtual::Return.new(Virtual::Reference , nil)
        method.source.add_code Virtual::Set.new( nil , to )
        to
      end

      def on_modulename expression
        clazz = Parfait::Space.object_space.get_class_by_name expression.name
        raise "compile_modulename #{clazz}.#{name}" unless clazz
        to = Virtual::Return.new(Virtual::Reference , clazz )
        method.source.add_code Virtual::Set.new( clazz , to )
        to
      end

  #    attr_reader  :string
      def on_string expression
        # Clearly a TODO here to implement strings rather than reusing symbols
        value = expression.first.to_sym
        to = Virtual::Return.new(Virtual::Reference , value)
        method.source.constants << value
        method.source.add_code Virtual::Set.new( value , to )
        to
      end

      #attr_reader  :left, :right
      def on_assignment expression
        unless expression.left.instance_of? Ast::NameExpression
          raise "must assign to NameExpression , not #{expression.left}"
        end
        r = process(expression.right  )
        raise "oh noo, nil from where #{expression.right.inspect}" unless r
        index = method.has_arg(expression.left.name.to_sym)
        if index
          method.source.add_code Virtual::Set.new(ArgSlot.new(index , r.type , r ) , Virtual::Return.new)
        else
          index = method.ensure_local(expression.left.name.to_sym)
          method.source.add_code Virtual::Set.new(FrameSlot.new(index , r.type , r ) , Virtual::Return.new)
        end
        r
      end

  end
end
