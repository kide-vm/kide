module Mom

  # A BlockCompiler is much like a MehtodCompiler, exept for blocks
  #
  class BlockCompiler < CallableCompiler

    attr_reader :block , :mom_instructions
    alias :block  :callable

    def initialize( block , method)
      @method = method
      super(block)
    end

    def source_name
      "#{@method.self_type.name}.init"
    end

    def to_risc(in_method)
      risc_compiler = Risc::BlockCompiler.new(@callable , in_method , mom_instructions)
      instructions_to_risc(risc_compiler)
      #recursive blocks not done
      risc_compiler
    end

    # determine how given name need to be accsessed.
    # For blocks the options are args or frame
    # or then the methods arg or frame
    def slot_type_for(name)
      if index = @callable.arguments_type.variable_index(name)
        return ["arg#{index}".to_sym]
      elsif @callable.frame_type.variable_index(name)
        slot_def = [:frame]
      elsif index = @method.arguments_type.variable_index(name)
        return [:caller , :caller , "arg#{index}".to_sym]
      elsif @method.frame_type.variable_index(name)
        slot_def = [:caller ,:caller , :frame ]
      elsif
        raise "no variable #{name} , need to resolve at runtime"
      end
      slot_def << name
    end


  end
end
