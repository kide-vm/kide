module Arm

  class GetImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Register::GetSlot
        load = ArmMachine.ldr( code.value ,  code.reference , code.index )
        block.replace(code , load )
      end
    end
  end
  Virtual::BootSpace.space.add_pass "Arm::GetImplementation"
end
