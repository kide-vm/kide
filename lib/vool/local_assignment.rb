module Vool

  class LocalAssignment < Assignment

    def to_mom( compiler )
      if compiler.method.arguments_type.variable_index(@name)
        type = :arguments
      else
        type = :frame
      end
      to = Mom::SlotDefinition.new(:message ,[ type , @name])
      from = @value.slot_definition(compiler)
      return chain_assign( Mom::SlotLoad.new(to,from) , compiler)
    end
  end

end
