module Arm

  class SetImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Register::SetSlot
        # times 4 because arm works in bytes, but vm in words
        # + 1 because of the type word
        store = ArmMachine.str( code.register ,  code.array , 4 * code.index )
        block.replace(code , store )
      end
    end
  end
  Virtual.machine.add_pass "Arm::SetImplementation"
end
