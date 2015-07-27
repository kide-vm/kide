module Register

  # save the return address of a call
  # register and index specify where the return address is stored

  # This instruction exists mainly, so we don't have to hard-code where the machine stores the
  # address. In arm that is a register, but intel may (?) push it, and who knows, what other machines do.

  class SaveReturn < Instruction
    def initialize source , register , index
      super(source)
      @register = register
      @index = index
    end
    attr_reader :register , :index

    def to_s
      "SaveReturn: #{register} [#{index}]"
    end

  end

  # Produce a SaveReturn instruction.
  # From is a register or symbol that can be transformed to a register by resolve_to_register
  # index resolves with resolve_index.
  def self.save_return code, from , index
    index = resolve_index( from , index)
    from = resolve_to_register from
    SaveReturn.new( code , from , index )
  end

end
