module Arm

  class SetImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Register::SetSlot
        store = ArmMachine.str( code.value ,  code.reference , code.index )
        block.replace(code , store )
      end
    end
  end
  Virtual::Machine.instance.add_pass "Arm::SetImplementation"
end
