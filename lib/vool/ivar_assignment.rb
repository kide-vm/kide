module Vool

  class IvarAssignment < Assignment

    def to_mom( compiler )
      to = Mom::SlotDefinition.new(:message ,[ :receiver , @name])
      from = @value.slot_definition(compiler)
      return chain_assign( Mom::SlotLoad.new(self,to,from) , compiler)
    end

  end
end
