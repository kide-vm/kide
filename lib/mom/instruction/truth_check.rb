module Mom

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
      false_label = @false_jump.to_risc(compiler)
      left = @condition.to_register(compiler,self)
      false_load = SlotDefinition.new( FalseConstant.new , [] ).to_register(compiler,self)
      left << false_load
      left << Risc.op( self , :- , left.register , false_load.register)
      left << Risc::IsZero.new( self, false_label)
      nil_load = SlotDefinition.new( NilConstant.new , [] ).to_register(compiler,self)
      left << nil_load
      left << Risc.op( self , :- , left.register , nil_load.register)
      left << Risc::IsZero.new( self, false_label)

      left
    end

  end
end
