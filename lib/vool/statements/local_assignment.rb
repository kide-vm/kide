module Vool

  class LocalAssignment < Assignment

    def normalize
      super
      return LocalAssignment.new(@name , @value)
    end

    def to_mom( method )
      if method.args_type.variable_index(@name)
        type = :arguments
      else
        type = :frame
      end
      to = Mom::SlotDefinition.new(:message ,[ type , @name])
      from = @value.slot_definition(method)
      return chain_assign( Mom::SlotLoad.new(to,from) , method)
    end
  end

end
