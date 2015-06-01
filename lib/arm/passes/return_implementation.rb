module Arm

  class ReturnImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Register::FunctionReturn
        load = ArmMachine.ldr( :pc ,  code.register , code.index )
        block.replace(code , load )
      end
    end
  end
  Virtual.machine.add_pass "Arm::ReturnImplementation"
end
