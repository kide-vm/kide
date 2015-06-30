module Arm

  class GetImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Register::GetSlot
        # times 4 because arm works in bytes, but vm in words
        load = ArmMachine.ldr( code.register ,  code.array , 4 * code.index )
        block.replace(code , load )
      end
    end
  end
  Virtual.machine.add_pass "Arm::GetImplementation"
end
