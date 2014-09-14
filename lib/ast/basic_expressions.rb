# collection of the simple ones, int and strings and such

module Ast

  # Constant expressions can by definition be evaluated at compile time.
  # But that does not solve their storage, ie they need to be accessible at runtime from _somewhere_
  # So we view ConstantExpressions like functions that return the value of the constant.
  # In other words, their storage is the return slot as it would be for a method

  # The current approach moves the constant into a varaible before using it
  # But in the future (in the one that holds great things) we optimize those unneccesay moves away
  
  class IntegerExpression < Expression
#    attr_reader :value
    def compile method , message
      to = Virtual::NewReturn.new(Virtual::Integer)
      method.add_code Virtual::Set.new( to , Virtual::IntegerConstant.new(value))
      to
    end
  end

  class TrueExpression
    def compile method , message
      to = Virtual::Return.new(Virtual::Reference)
      method.add_code Virtual::Set.new( to , Virtual::TrueConstant.new )
      to
    end
  end
  
  class FalseExpression
    def compile method , message
      to = Virtual::Return.new(Virtual::Reference)
      method.add_code Virtual::Set.new( to , Virtual::FalseConstant.new )
      to
    end
  end
  
  class NilExpression
    def compile method , message
      to = Virtual::Return.new(Virtual::Reference)
      method.add_code Virtual::Set.new( to , Virtual::NilConstant.new )
      to
    end
  end

  class NameExpression < Expression
#    attr_reader  :name

    # compiling name needs to check if it's a variable and if so resolve it
    # otherwise it's a method without args and a send is ussued.
    # this makes the namespace static, ie when eval and co are implemented method needs recompilation
    def compile method , message
      return Virtual::Self.new( Virtual::Mystery ) if name == :self
      if method.has_var(name)
        message.compile_get(method , name )
      else
        raise "Unimplemented #{self}" 
        message.compile_send( method , name ,  Virtual::Self.new( Virtual::Mystery ) )
      end
    end
  end

  class ModuleName < NameExpression

    def compile method , message
      to = Virtual::Return.new(Virtual::Reference)
      clazz = Virtual::BootSpace.space.get_or_create_class name
      raise "uups #{clazz}.#{name}" unless clazz
      method.add_code Virtual::Set.new( to , clazz )
      to
    end    
  end

  class StringExpression < Expression
#    attr_reader  :string
    def compile method , message
      to = Virtual::Return.new(Virtual::Reference)
      value = Virtual::StringConstant.new(string)
      Virtual::BootSpace.space.add_object value 
      method.add_code Virtual::Set.new( to , value )
      to
    end
  end
  class AssignmentExpression < Expression
    #attr_reader  :left, :right

    def compile method , message
      raise "must assign to NameExpression , not #{left}" unless left.instance_of? NameExpression 
      r = right.compile(method,message)
      raise "oh noo, nil from where #{right.inspect}" unless r
      message.compile_set( method , left.name , r )
    end
  end

  class VariableExpression < NameExpression
    def compile method , message
      method.add_code Virtual::InstanceGet.new(name)
      Virtual::NewReturn.new( Virtual::Mystery )
    end
  end
end