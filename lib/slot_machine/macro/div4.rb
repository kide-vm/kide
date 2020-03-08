module SlotMachine
  class Div4 < Macro
    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      integer_tmp = builder.allocate_int
      integer_1 = builder.register( :integer_1 )
      integer_self = builder.register( :integer_self )
      builder.build do
        integer_self = message[:receiver].to_reg.reduce_int(false)
        load_object( 2 , integer_1)
        integer_self.op :>> , integer_1
        integer_tmp[Parfait::Integer.integer_index] << integer_self
        message[:return_value] << integer_tmp
      end
      return compiler
    end
  end
end
