module SlotMachine
  class Div10 < Macro
    def to_risc(compiler)
      s = "div_10 "
      builder = compiler.builder(compiler.source)
      integer_tmp = builder.allocate_int
      integer_1 = builder.register( :integer_1 )
      integer_reg = builder.register( :integer_reg )
      integer_const = builder.register( :integer_const )
      builder.build do
        integer_self = message[:receiver].to_reg.reduce_int
        transfer( integer_self , integer_1)
        transfer( integer_self , integer_reg)

        load_object( Parfait::Integer.new(1) , integer_const)

        integer_1.op :>> , integer_const

        integer_const << 2
        integer_reg.op :>> , integer_const
        integer_reg.op :+ , integer_1

        integer_const << 4
        integer_1 << integer_reg
        integer_reg.op :>> , integer_1

        integer_reg.op :+ , integer_1

        integer_const << 8
        integer_1 << integer_reg
        integer_1.op :>> , integer_const

        integer_reg.op :+ , integer_1

        integer_const << 16
        integer_1 << integer_reg
        integer_1.op :>> , integer_const

        integer_reg.op :+ , integer_1

        integer_const << 3
        integer_reg.op :>> , integer_const

        integer_const << 10
        integer_1 << integer_reg
        integer_1.op :* , integer_const

        integer_self.op :- , integer_1
        integer_1 << integer_self

        integer_const << 6
        integer_1.op :+ , integer_const

        integer_const << 4
        integer_1.op :>> , integer_const

        integer_reg.op :+ , integer_1

        integer_tmp[Parfait::Integer.integer_index] << integer_reg
        message[:return_value] << integer_tmp

      end
      return compiler
    end
  end
end
