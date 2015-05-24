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
        int = IntegerConstant.new(expression.value)
        to = Return.new(Integer , int)
        method.info.add_code Set.new( to , int)
        to
      end

      def self.compile_true expression , method
        value = TrueConstant.new
        to = Return.new(Reference , value)
        method.info.add_code Set.new( to , value )
        to
      end

      def self.compile_false expression , method
        value = FalseConstant.new
        to = Return.new(Reference , value)
        method.info.add_code Set.new( to , value )
        to
      end

      def self.compile_nil expression , method
        value = NilConstant.new
        to = Return.new(Reference , value)
        method.info.add_code Set.new( to , value )
        to
      end

      #    attr_reader  :name
      # compiling name needs to check if it's a variable and if so resolve it
      # otherwise it's a method without args and a send is issued.
      # whichever way this goes the result is stored in the return slot (as all compiles)
      def self.compile_name expression , method
        return Self.new( Reference.new(method.for_class)) if expression.name == :self
        name = Virtual.new_word expression.name.to_s
        if method.has_var(name)
          # either an argument, so it's stored in message
          if( index = method.has_arg(name))
            method.info.add_code MessageGet.new(expression.name , index)
          else # or a local so it is in the frame
            method.info.add_code FrameGet.new(expression.name , index)
          end
        else
          call = Ast::CallSiteExpression.new(expression.name , [] ) #receiver self is implicit
          Compiler.compile(call, method)
        end
      end


      def self.compile_module expression , method
        clazz = Space.space.get_class_by_name name
        raise "uups #{clazz}.#{name}" unless clazz
        to = Return.new(Reference , clazz )
        method.info.add_code Set.new( to , clazz )
        to
      end

  #    attr_reader  :string
      def self.compile_string expression , method
        value = Virtual.new_word(expression.string)
        to = Return.new(Reference , value)
        Machine.instance.space.add_object value
        method.info.add_code Set.new( to , value )
        to
      end

      #attr_reader  :left, :right
      def self.compile_assignment expression , method
        raise "must assign to NameExpression , not #{expression.left}" unless expression.left.instance_of? Ast::NameExpression
        r = Compiler.compile(expression.right , method )
        raise "oh noo, nil from where #{expression.right.inspect}" unless r
        index = method.has_arg(Virtual.new_word name)
        if index
          method.info.add_code Set.new(Return.new , MessageSlot.new(index , r,type , r ))
        else
          index = method.ensure_local(Virtual.new_word expression.left.name)
          method.info.add_code Set.new(Return.new , FrameSlot.new(index , r.type , r ))
        end
        r
      end

      def self.compile_variable expression, method
        method.info.add_code InstanceGet.new(expression.name)
        Return.new( Mystery )
      end
  end
end
