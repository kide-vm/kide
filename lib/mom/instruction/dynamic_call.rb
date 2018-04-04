module Mom

  # A dynamic call calls a method at runtime. This off course implies that we don't know the
  # method at compile time and so must "find" it. Resolving, or finding the method, is a
  # a seperate step though, and here we assume that we know this Method instance.
  #
  # Both (to be called) Method instance and the type of receiver are stored as
  # variables here. The type is used to check before calling.
  #
  # Setting up the method is not part of the instructions scope. That setup
  # includes the type check and any necccessay method resolution.
  # See vool send statement
  #
  class DynamicCall < Instruction
    attr :cache_entry

    def initialize(type = nil, method = nil)
      @cache_entry = Parfait::CacheEntry.new(type, method)
    end

    # One could almost think that one can resolve this to a Risc::FunctionCall
    #  (which btw resolves to a simple jump), alas, the FunctionCall, like all other
    # jumping, resolves the address at compile time.
    #
    # Instead we need a DynamicJump instruction that explicitly takes a register as
    # a target (not a label)
    def to_risc(compiler)
      compiler.add_constant( @cache_entry )
      reg = compiler.use_reg( :Object )
      call =  Risc.load_constant( self , @cache_entry , reg )
      method_index = Risc.resolve_to_index(:cache_entry , :cached_method)
      call << Risc::SlotToReg.new( self , reg ,method_index, reg)
      call << Risc::DynamicJump.new(self, reg )
    end
  end

end
