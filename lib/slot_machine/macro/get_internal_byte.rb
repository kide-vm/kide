module SlotMachine
  class GetInternalByte < Macro
    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      integer_tmp = builder.allocate_int
      builder.build do
        object = message[:receiver].to_reg
        integer = message[:arg1].to_reg.reduce_int(false)
        object <= object[integer]
        integer_tmp[Parfait::Integer.integer_index] << object
        message[:return_value] << integer_tmp
      end
      return compiler
    end
  end
end
