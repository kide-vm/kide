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
      int = Virtual::IntegerConstant.new(expression.value)
      to = Virtual::Return.new(Virtual::Integer , int)
      method.add_code Virtual::Set.new( to , int)
      to
    end

    def self.compile_true expression , method
      value = Virtual::TrueConstant.new
      to = Virtual::Return.new(Virtual::Reference , value)
      method.add_code Virtual::Set.new( to , value )
      to
    end

    def self.compile_false expression , method
      value = Virtual::FalseConstant.new
      to = Virtual::Return.new(Virtual::Reference , value)
      method.add_code Virtual::Set.new( to , value )
      to
    end

    def self.compile_nil expression , method
      value = Virtual::NilConstant.new
      to = Virtual::Return.new(Virtual::Reference , value)
      method.add_code Virtual::Set.new( to , value )
      to
    end

    #    attr_reader  :name
    # compiling name needs to check if it's a variable and if so resolve it
    # otherwise it's a method without args and a send is issued.
    # whichever way this goes the result is stored in the return slot (as all compiles)
    def self.compile_name expression , method
      return Virtual::Self.new( Virtual::Mystery ) if expression.name == :self
      name = expression.name
      if method.has_var(expression.name)
        # either an argument, so it's stored in message
        if( index = method.has_arg(name))
          method.add_code MessageGet.new(name , index)
        else # or a local so it is in the frame
          method.add_code FrameGet.new(name , index)
        end
      else
        call = Ast::CallSiteExpression.new(expression.name , [] ) #receiver self is implicit
        Compiler.compile(call, method)
      end
    end


    def self.compile_module expression , method
      clazz = Virtual::BootSpace.space.get_or_create_class name
      raise "uups #{clazz}.#{name}" unless clazz
      to = Virtual::Return.new(Virtual::Reference , clazz )
      method.add_code Virtual::Set.new( to , clazz )
      to
    end

#    attr_reader  :string
    def self.compile_string expression , method
      value = Virtual::StringConstant.new(expression.string)
      to = Virtual::Return.new(Virtual::Reference , value)
      Virtual::BootSpace.space.add_object value
      method.add_code Virtual::Set.new( to , value )
      to
    end

    #attr_reader  :left, :right
    def self.compile_assignment expression , method
      raise "must assign to NameExpression , not #{expression.left}" unless expression.left.instance_of? Ast::NameExpression
      r = Compiler.compile(expression.right , method )
      raise "oh noo, nil from where #{expression.right.inspect}" unless r
      index = method.has_arg(name)
      if index
        method.add_code Virtual::Set.new(Virtual::Return.new , Virtual::MessageSlot.new(index , r,type , r ))
      else
        index = method.ensure_local(expression.left.name)
        method.add_code Virtual::Set.new(Virtual::Return.new , Virtual::FrameSlot.new(index , r.type , r ))
      end
      r
    end

    def self.compile_variable expression, method
      method.add_code Virtual::InstanceGet.new(expression.name)
      Virtual::Return.new( Virtual::Mystery )
    end
end
