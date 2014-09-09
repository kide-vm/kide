module Register
  # This implements setting of the various slot variables the vm defines. 
  # Basic mem moves, but have to shuffle the type nibbles
  
  class SetImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::Set
        if( code.to.is_a? Virtual::NewMessageSlot)
          to = RegisterReference.new(:r0)
          tmp = RegisterReference.new(:r5)
          move = RegisterMachine.instance.ldr( to , tmp , code.to.index )
          block.replace(code , move )
        else
          raise "Start coding #{code.inspect}"
        end
      end
    end
  end
  Virtual::BootSpace.space.add_pass_after SetImplementation , Virtual::GetImplementation
end
