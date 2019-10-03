module SlotMachine

  # The funny thing about the ruby truth is that it is anything but false or nil
  #
  # To implement the normal ruby logic, we check for false or nil and jump
  # to the false branch. true_block follows implicitly
  #
  class TruthCheck < Check
    attr_reader :condition

    def initialize(condition , false_jump)
      super(false_jump)
      @condition  = condition
      raise "condition must be slot_definition #{condition}" unless condition.is_a?(SlotDefinition)
    end

    def to_s
      "TruthCheck #{@condition} -> #{false_jump}"
    end

    def to_risc(compiler)
      false_label = @false_jump.risc_label(compiler)
      builder = compiler.builder("TruthCheck")
      condition_reg = @condition.to_register(compiler,self)
      builder.build do
        object! << Parfait.object_space.false_object
        object.op :- , condition_reg
        if_zero false_label
        object << Parfait.object_space.nil_object
        object.op :- , condition_reg
        if_zero false_label
      end
    end

  end
end
