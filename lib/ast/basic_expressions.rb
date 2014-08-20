# collection of the simple ones, int and strings and such

module Ast

  class IntegerExpression < Expression
#    attr_reader :value
    def compile method , message
      to = Virtual::Return.new(Integer)
      method.add_code Virtual::Set.new( to , Virtual::IntegerConstant.new(value))
      to
    end
  end

  class TrueExpression
    def compile method , message
      Virtual::TrueValue.new
    end
  end
  
  class FalseExpression
    def compile method , message
      Virtual::FalseValue.new
    end
  end
  
  class NilExpression
    def compile method , message
      Virtual::NilValue.new
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
        raise "Unimplemented" 
        message.compile_send( method , name ,  Virtual::Self.new( Virtual::Mystery.new ) )
      end
    end
  end

  class ModuleName < NameExpression

    def compile method , message
      clazz = ::Virtual::Object.space.get_or_create_class name
      raise "uups #{clazz}.#{name}" unless clazz
      #class qualifier, means call from metaclass
      #clazz = clazz.meta_class
      clazz
    end    
  end

  class StringExpression < Expression
#    attr_reader  :string
    def compile method , message
      value = Virtual::StringConstant.new(string)
      ::Virtual::Object.space.add_object value 
      value
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
    def old_scratch
      if operator == "="    # assignment, value based
        if(left.is_a? VariableExpression)
          left.make_setter
          l_val = left.compile(context)
        elsif left.is_a?(NameExpression)
          puts context.inspect unless context.locals
          l_val = context.locals[left.name]
          if( l_val ) #variable existed, move data there
            l_val = l_val.move( into , r_val) 
          else
            l_val = context.function.new_local.move( into , r_val )
          end
          context.locals[left.name] = l_val
        else
          raise "Can only assign variables, not #{left}" 
        end
        return l_val
      end
    end
  end

  class VariableExpression < NameExpression
    def compile method , message
      method.add_code Virtual::ObjectGet.new(name)
      Virtual::Return.new( Virtual::Mystery.new )
    end
  end
end