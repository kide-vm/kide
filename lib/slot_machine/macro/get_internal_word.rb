module SlotMachine
  class GetInternalWord < Macro
    def to_risc(compiler)
      compiler.builder(compiler.source).build do
        integer = message[:arg1].reduce_int(false)
        message[:return_value] << message[:receiver][integer]
      end
    end
  end
end
