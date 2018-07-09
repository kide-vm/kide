module Risc

  # A BlockCompiler is much like a Mehtodcompiler, exept for blocks
  #
  class BlockCompiler

    attr_reader :block , :risc_instructions , :constants

    def initialize( block , method)
      @method = method
      @regs = []
      @block = block
      name = "#{method.self_type.name}.init"
      @risc_instructions = Risc.label(name, name)
      @risc_instructions << Risc.label( name, "unreachable")
      @current = @risc_instructions
      @constants = []
    end

    # determine how given name need to be accsessed.
    # For blocks the options are args or frame
    # or then the methods arg or frame
    def slot_type_for(name)
      if @block.arguments_type.variable_index(name)
        slot_def = [ :arguments]
      elsif @block.frame_type.variable_index(name)
        slot_def = [:frame]
      elsif @method.arguments_type.variable_index(name)
        slot_def = [:caller , :arguments ]
      elsif @method.arguments_type.variable_index(name)
        slot_def = [:caller , :frame ]
      elsif
        raise "no variable #{name} , need to resolve at runtime"
      end
      slot_def << name
    end

  end
end
