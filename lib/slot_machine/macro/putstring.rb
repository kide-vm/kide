module SlotMachine
  class Putstring < Macro
    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      integer = builder.prepare_int_return # makes integer_tmp variable as return
      word = Risc.syscall_reg(2).set_compiler(compiler)
      length = Risc.syscall_reg(3).set_compiler(compiler)
      builder.build do
        string = message[:receiver].to_reg.known_type(:Word)
        integer << string[:char_length]
        word << string     # into right
        length << integer  # registers
      end
      SlotMachine::Macro.emit_syscall( builder , :putstring )
      compiler
    end
  end
end
