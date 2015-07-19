module Virtual
  # collection of the simple ones, int and strings and such

  module Compiler

    # Constant expressions can by definition be evaluated at compile time.
    # But that does not solve their storage, ie they need to be accessible at runtime from _somewhere_
    # So we view ConstantExpressions like functions that return the value of the constant.
    # In other words, their storage is the return slot as it would be for a method

    # The current approach moves the constant into a variable before using it
    # But in the future (in the one that holds great things) we optimize those unneccesay moves away

  #    attr_reader :value
      def self.compile_integer expression , method
        int = expression.value
        to = Return.new(Integer , int)
        method.source.add_code Set.new( int , to )
        to
      end

      def self.compile_true expression , method
        to = Return.new(Reference , true )
        method.source.add_code Set.new( true , to )
        to
      end

      def self.compile_false expression , method
        to = Return.new(Reference , false)
        method.source.add_code Set.new( false , to )
        to
      end

      def self.compile_nil expression , method
        to = Return.new(Reference , nil)
        method.source.add_code Set.new( nil , to )
        to
      end

      def self.compile_module expression , method
        clazz = Space.space.get_class_by_name name
        raise "uups #{clazz}.#{name}" unless clazz
        to = Return.new(Reference , clazz )
        method.source.add_code Set.new( clazz , to )
        to
      end

  #    attr_reader  :string
      def self.compile_string expression , method
        # Clearly a TODO here to implement strings rather than reusing symbols
        value = expression.string.to_sym
        to = Return.new(Reference , value)
        method.source.constants << value
        method.source.add_code Set.new( value , to )
        to
      end

      #attr_reader  :left, :right
      def self.compile_assignment expression , method
        unless expression.left.instance_of? Ast::NameExpression
          raise "must assign to NameExpression , not #{expression.left}"
        end
        r = Compiler.compile(expression.right , method )
        raise "oh noo, nil from where #{expression.right.inspect}" unless r
        index = method.has_arg(expression.left.name.to_sym)
        if index
          method.source.add_code Set.new(MessageSlot.new(index , r,type , r ) , Return.new)
        else
          index = method.ensure_local(expression.left.name.to_sym)
          method.source.add_code Set.new(FrameSlot.new(index , r.type , r ) , Return.new)
        end
        r
      end

      def self.compile_variable expression, method
        method.source.add_code InstanceGet.new(expression.name)
        Return.new( Unknown )
      end
  end
end
