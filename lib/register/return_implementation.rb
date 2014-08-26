module Register
  class ReturnImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodReturn
        to = RegisterReference.new(:r0)
        tmp = RegisterReference.new(:r5)
        pc = RegisterReference.new(:pc)
        move1 = RegisterMachine.instance.ldr( to , tmp , 3 ) #TODO 3 == return reg, needs constant / layout
        move2 = RegisterMachine.instance.ldr( pc , tmp )
        block.replace(code , [move1,move2] )
      end
    end
  end
  Virtual::BootSpace.space.add_pass_after ReturnImplementation , CallImplementation 
end
