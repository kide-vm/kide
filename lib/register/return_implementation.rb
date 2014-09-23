module Register
  class ReturnImplementation
    def run block
      block.codes.dup.each do |code|
        
        #TODO
        - move message to new meesage 
        - restore caller message and self / frame
        next unless code.is_a? Virtual::MethodReturn
        #load the return address into pc, affecting return. (other cpus have commands for this, but not arm)
        message = RegisterReference.new(:r0)
        pc = RegisterReference.new(:pc)
        move1 = RegisterMachine.instance.ldr( pc ,message , Virtual::Slot::MESSAGE_RETURN_VALUE )
        block.replace(code , [move1] )
      end
    end
  end
  Virtual::BootSpace.space.add_pass_after ReturnImplementation , CallImplementation 
end
