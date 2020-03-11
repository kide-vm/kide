module SlotMachine
  class SetInternalByte < Macro
    def to_risc(compiler)
      compiler.builder(compiler.source).build do
        message[:return_value] << message[:arg2]
        integer = message[:arg1].reduce_int(false)
        message[:receiver][integer] <= message[:arg2].reduce_int(false)
      end
      return compiler
    end
  end
end
