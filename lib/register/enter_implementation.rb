module Register

  class EnterImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodEnter
        new_codes = []
        # save return register and create a new frame
        # lr is link register, ie where arm stores the return address when call is issued
        new_codes << RegisterMachine.instance.str( :lr , Virtual::Slot::MESSAGE_REGISTER , Virtual::Slot::MESSAGE_RETURN_ADDRESS )
        new_codes << Virtual::NewFrame.new
        block.replace(code , new_codes )
      end
    end
  end
  Virtual::BootSpace.space.add_pass_after EnterImplementation , CallImplementation
end
