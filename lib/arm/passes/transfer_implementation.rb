module Arm

  class TransferImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Register::RegisterTransfer
        # Register machine convention is from => to
        # But arm has the receiver/result as the first
        move = ArmMachine.mov( code.to , code.from)
        block.replace(code , move )
      end
    end
  end
  Virtual.machine.add_pass "Arm::TransferImplementation"
end
