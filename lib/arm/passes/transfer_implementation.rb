module Arm

  class TransferImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Register::RegisterTransfer
        move = ArmMachine.mov( code.from , code.to )
        block.replace(code , move )
      end
    end
  end
  Virtual.machine.add_pass "Arm::TransferImplementation"
end
