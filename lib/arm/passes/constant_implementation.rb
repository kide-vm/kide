module Arm

  class ConstantImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Register::LoadConstant
        constant = code.constant

        if constant.is_a?(Parfait::Object) or constant.is_a? Symbol
          load = ArmMachine.add( code.register , constant )
        else
          load = ArmMachine.mov( code.register ,  code.constant )
        end
        block.replace(code , load )
        #puts "replaced #{load.inspect.to_s[0..1000]}"
      end
    end
  end
  Virtual.machine.add_pass "Arm::ConstantImplementation"
end
