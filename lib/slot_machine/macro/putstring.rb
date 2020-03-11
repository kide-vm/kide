module SlotMachine
  class Putstring < Macro
    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      integer = builder.prepare_int_return # makes integer_tmp variable as return
      builder.build do
        word = message[:receiver].to_reg.known_type(:Word)
        integer << word[:char_length]
      end
      SlotMachine::Macro.emit_syscall( builder , :putstring )
      compiler
    end
  end
end
