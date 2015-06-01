module Arm

  # Arm stores the return address in a register (not on the stack)
  # The register is called link , or lr for short .
  # Maybe because it provides the "link" back to the caller (?)

  # the vm defines a register for the location, so we store it there.

  class SaveImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Register::SaveReturn
        store = ArmMachine.str( :lr ,  code.register , code.index )
        block.replace(code , store )
      end
    end
  end
  Virtual.machine.add_pass "Arm::SaveImplementation"
end
