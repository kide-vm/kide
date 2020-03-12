module SlotMachine
  class SetInternalWord < Macro
    def to_risc(compiler)
      compiler.builder(compiler.source).build do
        integer = message[:arg1].to_reg.reduce_int(false)
        object_reg = message[:arg2].to_reg
        message[:receiver][integer] << object_reg
        message[:return_value] << object_reg
      end
      return compiler
    end
  end
end
