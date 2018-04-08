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

    # resolve the method name of self, on the given object
    # may seem wrong way around at first sight, but we know the type of string. And
    # thus resolving this method happens at compile time, whereas any method on an
    # unknown self (the object given) needs resolving and that is just what we are doing
    #  ( ie the snake bites it's tail)
    # This method is just a placeholder until boot is over and the real method is
    # parsed.
    def to_risc( compiler )
      name = @name
      cache_entry = @cache_entry
      return Risc.label("hi" , "there")
      builder = compiler.builder(false)
      builder.build do
        word << name

        type << cache_entry
        type << type[:cached_type]
        typed_method << type[:methods]

        add while_start_label
        space << Parfait.object_space
        space << space[:nil_object]

        space - typed_method
        if_zero exit_label

        name << typed_method[:name]
        name - word

        if_not_zero false_label
        message[:return_value] << typed_method
        add Mom::ReturnSequence.new.to_risc(compiler)

        add false_label
        typed_method << typed_method[:next_method]
        branch  while_start_label

        add exit_label
      end
      Risc::Builtin::Object.emit_syscall( builder , :exit )
      return builder.built
    end

  end
end
