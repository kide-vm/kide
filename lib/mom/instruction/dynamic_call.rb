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

    def to_risc(context)
      Risc::Label.new(self,"DynamicCall")
    end
  end

end
