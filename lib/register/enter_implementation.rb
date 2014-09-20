module Register

  class EnterImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodEnter
        # save return register and create a new frame
        to = RegisterReference.new(:r0)  # message base
        pc = RegisterReference.new(:pc)
        move1 = RegisterMachine.instance.str( pc , to , Virtual::Slot::MESSAGE_RETURN_VALUE )
        block.replace(code , [move1] )
      end
    end
  end
  Virtual::BootSpace.space.add_pass_after EnterImplementation , CallImplementation
end
