module SlotMachine

  # The funny thing about the ruby truth is that it is anything but false or nil
  #
  # To implement the normal ruby logic, we check for false or nil and jump
  # to the false branch. true_block follows implicitly
  #
  class TruthCheck < Check
    attr_reader :condition

    def initialize(condition , false_label)
      super(false_label)
      @condition  = condition
      raise "condition must be slot_definition #{condition}" unless condition.is_a?(Slotted)
    end

    def to_s
      "TruthCheck #{@condition} -> #{false_label}"
    end

    def to_risc(compiler)
      false_label = @false_label.risc_label(compiler)
      condition_reg = @condition.to_register(compiler,self)

      compiler.build(self.to_s) do
        object = load_object Parfait.object_space.false_object
        object.op :- , condition_reg
        if_zero false_label
        object = load_object Parfait.object_space.nil_object
        object.op :- , condition_reg
        if_zero false_label
      end
    end

  end
end
