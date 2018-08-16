module Risc

  # A BlockCompiler is much like a Mehtodcompiler, exept for blocks
  #
  class BlockCompiler < CallableCompiler

    attr_reader :block , :risc_instructions , :constants
    alias :block  :callable

    def initialize( block , method)
      @method = method
      super(block)
    end

    def source_name
      "#{@method.self_type.name}.init"
    end

    # resolve the type of the slot, by inferring from it's name, using the type
    # scope related slots are resolved by the compiler by method/block
    #
    # This mainly calls super, and only for :caller adds extra info
    # Using the info, means assuming that the block is not passed around (FIXME in 2020)
    def slot_type( slot , type)
      new_type = super
      if slot == :caller
        extra_info = { type_frame: @method.frame_type ,
                       type_arguments: @method.arguments_type ,
                       type_self: @method.self_type}
      end
      return new_type , extra_info
    end
    # determine how given name need to be accsessed.
    # For blocks the options are args or frame
    # or then the methods arg or frame
    def slot_type_for(name)
      if @callable.arguments_type.variable_index(name)
        slot_def = [:arguments]
      elsif @callable.frame_type.variable_index(name)
        slot_def = [:frame]
      elsif @method.arguments_type.variable_index(name)
        slot_def = [:caller , :caller ,:arguments ]
      elsif @method.frame_type.variable_index(name)
        slot_def = [:caller ,:caller , :frame ]
      elsif
        raise "no variable #{name} , need to resolve at runtime"
      end
      slot_def << name
    end


  end
end
