module Typed
  module Assignment

    def on_Assignment( statement )
      #      name , value = *statement
      reset_regs # statements reset registers, ie have all at their disposal
      value = process(statement.value)
      raise "Not register #{v}" unless value.is_a?(Register::RegisterValue)
      code = get_code( statement  , value)
      raise "must define variable #{statement.name.name} before using it in #{@method.inspect}" unless code
      add_code code
    end

    private

    def get_code( statement , value)
      name = no_space(statement.name).name
      named_list = use_reg(:NamedList)
      if( index = @method.has_arg(name))
         # TODO, check type @method.arguments[index].type
         type = :arguments
       else
         # or a local so it is in the frame
         index = @method.has_local( name )
         type = :locals
         return nil unless index
      end
      # TODO, check type  @method.locals[index].type
      add_code Register.get_slot(statement , :message , type , named_list )
      return Register.set_slot(statement , value , named_list , index )
    end
  end
end
