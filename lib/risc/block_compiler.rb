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

  end
end
