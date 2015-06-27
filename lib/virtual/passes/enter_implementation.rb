module Virtual

  class EnterImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodEnter
        new_codes = []
        # save return register and create a new frame
        # lr is link register, ie where arm stores the return address when call is issued
        new_codes << Register::SaveReturn.new( Register::RegisterReference.message_reg , Virtual::RETURN_INDEX )
        new_codes << Virtual::NewFrame.new
        block.replace(code , new_codes )
      end
    end
  end
  Virtual.machine.add_pass "Virtual::EnterImplementation"
end
