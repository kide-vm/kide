module Arm
  # This implements branch logic, which is simply assembler branch
  #
  # The only target for a call is a Block, so we just need to get the address for the code
  # and branch to it.
  #
  class BranchImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Register::Branch
        br = ArmMachine.b( code.block )
        block.replace(code , br )
      end
    end
  end
  Virtual.machine.add_pass "Arm::BranchImplementation"
end
