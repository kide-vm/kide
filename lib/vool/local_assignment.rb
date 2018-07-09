module Vool

  class LocalAssignment < Assignment

    def to_mom( compiler )
      slot_def = compiler.slot_type_for(@name)
      to = Mom::SlotDefinition.new(:message ,slot_def)
      from = @value.slot_definition(compiler)
      return chain_assign( Mom::SlotLoad.new(to,from) , compiler)
    end
  end

end
