module Risc

  # A BlockCompiler is much like a Mehtodcompiler, exept for blocks
  #
  class BlockCompiler < CallableCompiler

    attr_reader :block , :risc_instructions , :constants , :in_method

    def initialize( block , in_method , mom_label)
      @in_method = in_method
      super(block , mom_label)
    end

    def source_name
      "#{@in_method.self_type.name}.init"
    end

    # resolve the type of the slot, by inferring from it's name, using the type
    # scope related slots are resolved by the compiler by method/block
    #
    # This mainly calls super, and only for :caller adds extra info
    # Using the info, means assuming that the block is not passed around (FIXME in 2020)
    def slot_type( slot , type)
      new_type = super
      if slot == :caller
        extra_info = { type_frame: @in_method.frame_type ,
                       type_arguments: @in_method.arguments_type ,
                       type_self: @in_method.self_type}
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
      elsif @in_method.arguments_type.variable_index(name)
        slot_def = [:caller , :caller ,:arguments ]
      elsif @in_method.frame_type.variable_index(name)
        slot_def = [:caller ,:caller , :frame ]
      elsif
        raise "no variable #{name} , need to resolve at runtime"
      end
      slot_def << name
    end


  end
end
