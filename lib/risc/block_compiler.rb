module Risc

  # A BlockCompiler is much like a MethodCompiler, exept for it's for blocks
  # This only changes scoping for variables, lsee slot_type
  #
  class BlockCompiler < CallableCompiler

    attr_reader :block , :risc_instructions , :constants , :in_method

    def initialize( block , in_method , slot_label)
      @in_method = in_method
      super(block , slot_label)
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


  end
end
