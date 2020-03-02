module SlotMachine

  # A dynamic call calls a method at runtime. This off course implies that we don't know the
  # method at compile time and so must "find" it. Resolving, or finding the method, is a
  # a seperate instruction though, and here we assume that we know this Method instance.
  #
  # Both (to be called) Method instance and the type of receiver are stored as
  # variables here. The type is used to check before calling.
  #
  # Setting up the method is not part of this instructions scope. That setup
  # includes the type check and any necccessay method resolution.
  # See sol send statement
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
      entry = @cache_entry
      compiler.add_constant( entry )
      return_label = Risc.label(self, "continue_#{object_id}")
      compiler.build("DynamicCall") do
        return_address! << return_label
        next_message! << message[:next_message]
        next_message[:return_address] << return_address
        message << message[:next_message]
        cache_entry! << entry
        cache_entry << cache_entry[:cached_method]
        add_code Risc::DynamicJump.new("DynamicCall", cache_entry )
        add_code return_label
      end
    end
  end

end
