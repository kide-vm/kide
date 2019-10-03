module SlotMachine

  # A BlockCompiler is much like a MehtodCompiler, exept for blocks
  #
  class BlockCompiler < CallableCompiler

    attr_reader :block , :slot_instructions
    alias :block  :callable

    def initialize( block , method)
      @method = method
      super(block)
    end

    def source_name
      "#{@method.self_type.name}.init"
    end

    def to_risc
      risc_compiler = Risc::BlockCompiler.new(@callable , @method , slot_instructions)
      instructions_to_risc(risc_compiler)
      #recursive blocks not done
      risc_compiler
    end

    # determine how given name need to be accsessed.
    # For blocks the options are args or frame
    # or then the methods arg or frame
    def slot_type_for(name)
      if index = @callable.arguments_type.variable_index(name)
        slot_def = ["arg#{index}".to_sym]
      elsif index = @callable.frame_type.variable_index(name)
        slot_def = ["local#{index}".to_sym]
      elsif index = @method.arguments_type.variable_index(name)
        slot_def = [:caller , :caller , "arg#{index}".to_sym]
      elsif index = @method.frame_type.variable_index(name)
        slot_def = [:caller ,:caller , "local#{index}".to_sym ]
      elsif
        raise "no variable #{name} , need to resolve at runtime"
      end
      return slot_def
    end


  end
end
