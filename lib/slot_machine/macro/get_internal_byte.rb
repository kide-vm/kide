module SlotMachine
  class GetInternalByte < Macro
    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      integer_tmp = builder.allocate_int
      builder.build do
        integer_1 = register(:integer_1)
        object = message[:receiver].to_reg
        integer = message[:arg1].reduce_int(false)
        integer_1 <= object[integer]
        integer_tmp[Parfait::Integer.integer_index] << integer_1
        message[:return_value] << integer_tmp
      end
      return compiler
    end
  end
end
