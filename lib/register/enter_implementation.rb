module Register

  class EnterImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodEnter
        # save return register and create a new frame
        to = RegisterReference.new(:r0)  # message base
        tmp = RegisterReference.new(:r5) # tmp
        pc = RegisterReference.new(:pc)
        move1 = RegisterMachine.instance.ldr( tmp , pc )
        move2 = RegisterMachine.instance.ldr( tmp , to , 3 ) #TODO 3 == return reg, needs constant / layout
        block.replace(code , [move1,move2] )
      end
    end
  end
  Virtual::BootSpace.space.add_pass_after EnterImplementation , CallImplementation
end
