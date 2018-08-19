module Mom

  # Dynamic method resolution is at the heart of a dynamic language, and here
  # is the Mom level instruction to do it.
  #
  # When the static type can not be determined a CacheEntry is used to store
  # type and method of the resolved method. The CacheEntry is shared with
  # DynamicCall instruction who is responsible for calling the method in the entry.
  #
  # This instruction resolves the method, in case the types don't match (and
  # at least on first encouter)
  #
  # This used to be a method, but we don't really need the method setup etc
  #
  class ResolveMethod < Instruction
    attr :cache_entry , :name

    def initialize(name , cache_entry)
      @name = name
      @cache_entry = cache_entry
    end

    def to_s
      "ResolveMethod #{name}"
    end

    # When the method is resolved, a cache_entry is used to hold the result.
    # That cache_entry (holding type and method) is checked before, and
    # needs to be updated by this instruction.
    #
    # We use the type stored in the cache_entry to check the methods if any of it's
    # names are the same as the given @name
    #
    # currently a fail results in sys exit
    def to_risc( compiler )
      name_ = @name
      cache_entry_ = @cache_entry
      builder = compiler.builder(self)
      builder.build do
        word! << name_
        cache_entry! << cache_entry_

        type! << cache_entry[:cached_type]
        callable_method! << type[:methods]

        add_code while_start_label

        space! << Parfait.object_space
        space << space[:nil_object]
        space - callable_method
        if_zero exit_label

        name! << callable_method[:name]
        name - word

        if_zero ok_label

        callable_method << callable_method[:next_callable]
        branch  while_start_label

        add_code exit_label
        Risc::Builtin::Object.emit_syscall( builder , :exit )

        add_code ok_label
        cache_entry[:cached_method] << callable_method
      end
    end

  end
end
