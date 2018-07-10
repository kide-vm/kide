module Risc

  # A BlockCompiler is much like a Mehtodcompiler, exept for blocks
  #
  class BlockCompiler < CallableCompiler

    attr_reader :block , :risc_instructions , :constants

    def initialize( block , method)
      @method = method
      @block = block
      super()
    end

    def source_name
      "#{@method.self_type.name}.init"
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

    # resolve a symbol to a type. Allowed symbols are :frame , :receiver and arguments
    # which return the respective types, otherwise nil
    def resolve_type( name )
      case name
      when :frame
        return @block.frame_type
      when :arguments
        return @block.arguments_type
      when :receiver
        return @block.self_type
      else
        return nil
      end
    end

  end
end
