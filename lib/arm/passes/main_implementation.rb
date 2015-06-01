module Arm

  # "Boot" the register machine at the function given

  class MainImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Register::RegisterMain
        call = ArmMachine.b( code.method )
        block.replace(code , call )
      end
    end
  end
  Virtual.machine.add_pass "Arm::MainImplementation"
end
