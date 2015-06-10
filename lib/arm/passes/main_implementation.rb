module Arm

  # "Boot" the register machine at the function given
  # meaning jump to that function currently. Maybe better to do some machine setup
  # and possibly some cleanup/exit has to tie in, but that is not this day

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
