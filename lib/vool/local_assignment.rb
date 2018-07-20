module Vool

  class LocalAssignment < Assignment

    def to_mom( compiler )
      slot_def = compiler.slot_type_for(@name)
      to = Mom::SlotDefinition.new(:message ,slot_def)
      from = @value.slot_definition(compiler)
      return chain_assign( Mom::SlotLoad.new(to,from) , compiler)
    end

    def chain_assign(assign , compiler)
      return assign unless @value.is_a?(SendStatement)
      @value.to_mom(compiler) << assign
    end
  end

end
