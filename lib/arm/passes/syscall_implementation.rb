module Arm

  class SyscallImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Register::Syscall
        raise "uups" unless code.name == :putstring
        new_codes = [ ArmMachine.mov( :r1 ,  20 ) ]
        new_codes << ArmMachine.ldr( :r0 , Virtual::Slot::MESSAGE_REGISTER, Virtual::SELF_INDEX)
        new_codes << ArmMachine.mov( :r7 ,  4 )
        new_codes << ArmMachine.swi( 0 )
        block.replace(code , new_codes )
      end
    end
  end
  Virtual.machine.add_pass "Arm::SyscallImplementation"
end
