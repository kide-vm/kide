module Mom

  # A dynamic call calls a method at runtime. This off course implies that we don't know the
  # method at compile time and so must "find" it. Resolving, or finding the method, is a
  # a seperate instruction though, and here we assume that we know this Method instance.
  #
  # Both (to be called) Method instance and the type of receiver are stored as
  # variables here. The type is used to check before calling.
  #
  # Setting up the method is not part of this instructions scope. That setup
  # includes the type check and any necccessay method resolution.
  # See vool send statement
  #
  class DynamicCall < Instruction
    attr :cache_entry

    def initialize(type = nil, method = nil)
      @cache_entry = Parfait::CacheEntry.new(type, method)
    end

    def to_s
      str = "DynamicCall "
      str += cache_entry.cached_method&.name if cache_entry
      str
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
      return_label = Risc.label(self, "continue_#{object_id}")
      save_return =  SlotLoad.new([:message,:next_message,:return_address],[return_label],self)
      moves = save_return.to_risc(compiler)
      moves << Risc.slot_to_reg(self, :message , :next_message , Risc.message_reg)
      moves <<  Risc.load_constant( self , @cache_entry , reg )
      method_index = Risc.resolve_to_index(:cache_entry , :cached_method)
      moves << Risc::SlotToReg.new( self , reg ,method_index, reg)
      moves << Risc::DynamicJump.new(self, reg )
      moves << return_label
    end
  end

end
