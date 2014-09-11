module Register
  class ReturnImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodReturn
        #load the return address into pc, affecting return. (other cpus have commands for this, but not arm)
        message = RegisterReference.new(:r0)
        pc = RegisterReference.new(:pc)
        move1 = RegisterMachine.instance.ldr( pc ,message , Virtual::Message::RETURN )
        block.replace(code , [move1] )
      end
    end
  end
  Virtual::BootSpace.space.add_pass_after ReturnImplementation , CallImplementation 
end
