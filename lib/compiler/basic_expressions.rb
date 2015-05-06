# collection of the simple ones, int and strings and such

module Compiler

  # Constant expressions can by definition be evaluated at compile time.
  # But that does not solve their storage, ie they need to be accessible at runtime from _somewhere_
  # So we view ConstantExpressions like functions that return the value of the constant.
  # In other words, their storage is the return slot as it would be for a method

  # The current approach moves the constant into a variable before using it
  # But in the future (in the one that holds great things) we optimize those unneccesay moves away

#    attr_reader :value
    def self.compile_integer expession , method
      int = Virtual::IntegerConstant.new(expession.value)
      to = Virtual::Return.new(Virtual::Integer , int)
      method.add_code Virtual::Set.new( to , int)
      to
    end

    def self.compile_true expession , method
      value = Virtual::TrueConstant.new
      to = Virtual::Return.new(Virtual::Reference , value)
      method.add_code Virtual::Set.new( to , value )
      to
    end

    def self.compile_false expession , method
      value = Virtual::FalseConstant.new
      to = Virtual::Return.new(Virtual::Reference , value)
      method.add_code Virtual::Set.new( to , value )
      to
    end

    def self.compile_nil expession , method
      value = Virtual::NilConstant.new
      to = Virtual::Return.new(Virtual::Reference , value)
      method.add_code Virtual::Set.new( to , value )
      to
    end

#    attr_reader  :name
    # compiling name needs to check if it's a variable and if so resolve it
    # otherwise it's a method without args and a send is usued.
    # this makes the namespace static, ie when eval and co are implemented method needs recompilation
    def self.compile_name expession , method
      return Virtual::Self.new( Virtual::Mystery ) if expession.name == :self
      if method.has_var(expession.name)
        message.compile_get(method , expession.name )
      else
        raise "TODO unimplemented branch #{expession.class}(#{expession})"
        message.compile_send( method , expession.name ,  Virtual::Self.new( Virtual::Mystery ) )
      end
    end


    def self.compile_module expession , method
      clazz = Virtual::BootSpace.space.get_or_create_class name
      raise "uups #{clazz}.#{name}" unless clazz
      to = Virtual::Return.new(Virtual::Reference , clazz )
      method.add_code Virtual::Set.new( to , clazz )
      to
    end

#    attr_reader  :string
    def self.compile_string expession , method
      value = Virtual::StringConstant.new(expession.string)
      to = Virtual::Return.new(Virtual::Reference , value)
      Virtual::BootSpace.space.add_object value
      method.add_code Virtual::Set.new( to , value )
      to
    end

    #attr_reader  :left, :right
    def self.compile_assignment expession , method
      raise "must assign to NameExpression , not #{expession.left}" unless expession.left.instance_of? Ast::NameExpression
      r = Compiler.compile(expession.right , method )
      raise "oh noo, nil from where #{expession.right.inspect}" unless r
      index = method.has_arg(name)
      if index
        method.add_code Virtual::Set.new(Virtual::Return.new , Virtual::MessageSlot.new(index , r,type , r ))
      else
        index = method.ensure_local(expession.left.name)
        method.add_code Virtual::Set.new(Virtual::Return.new , Virtual::FrameSlot.new(index , r.type , r ))
      end
      r
    end

    def self.compile_variable expession, method
      method.add_code Virtual::InstanceGet.new(expession.name)
      Virtual::Return.new( Virtual::Mystery )
    end
end
