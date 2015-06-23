module Arm

  class SyscallImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Register::Syscall
        new_codes = []
        load = ArmMachine.ldr( :r1 ,  code.constant )

        store = ArmMachine.str( code.register ,  code.array , code.index )
        block.replace(code , new_codes )
      end
    end
  end
  Virtual.machine.add_pass "Arm::SetImplementation"
end
