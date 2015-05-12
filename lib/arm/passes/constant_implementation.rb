module Arm

  class ConstantImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Register::LoadConstant
        load = ArmMachine.ldr( code.value ,  code.constant )
        block.replace(code , load )
      end
    end
  end
  Virtual::Machine.instance.add_pass "Arm::ConstantImplementation"
end
