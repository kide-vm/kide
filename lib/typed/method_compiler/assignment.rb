module Typed
  module Assignment

    def on_Assignment( statement )
      reset_regs # statements reset registers, ie have all at their disposal
      value = process(statement.value)
      raise "Not register #{v}" unless value.is_a?(Register::RegisterValue)
      name = check_name(statement.name.name)
      named_list = use_reg(:NamedList)
      if( index = @method.has_arg(name))
         type = :arguments
         value_type = @method.argument_type( index )
       else
         index = @method.has_local( name )
         type = :locals
         raise "must define variable #{statement.name.name} before using it in #{@method.inspect}" unless index
         value_type = @method.locals_type( index )
      end
      raise "Type mismatch for #{type} access #{value.type}!=#{value_type}" unless value.type == value_type
      add_slot_to_reg(statement , :message , type , named_list )
      add_reg_to_slot(statement , value , named_list , index + 1 ) # one for type
    end

    # ensure the name given is not space and raise exception otherwise
    # return the name
    def check_name( name )
      raise "space is a reserved name" if name == :space
      name
    end

  end
end
