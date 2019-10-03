module SlotMachine

  # the return jump jumps to the return label
  # the method setup is such that there is exactly one return_label in a method
  # This is so the actual code that executes the return can be quite complicated
  # and big, and won't be repeated
  #
  class ReturnJump < Instruction

    attr_reader :return_label

    # pass in the source_name (string/vool_instruction) for accounting purposes
    # and the return_label, where we actually jump to. This is set up by the
    # method_compiler, so it is easy to find (see return_label in compiler)
    def initialize( source , label )
      super(source)
      @return_label = label
    end

    # the jump quite simple resolves to an uncondition risc Branch
    # we use the label that is passed in at creation
    def to_risc(compiler)
      compiler.add_code Risc::Branch.new(self , return_label.risc_label(compiler))
    end

    def to_s
      "ReturnJump: #{return_label}"
    end
  end


end
