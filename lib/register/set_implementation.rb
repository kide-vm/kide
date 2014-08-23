module Register
  # This implements the send logic
  # Send is so complicated that we actually code it in ruby and stick it in
  # That off course opens up an endless loop possibility that we stop by reducing to Class and Module methods
  class SetImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::Set
        if( code.to.is_a? Virtual::NewMessageSlot)
          to = RegisterReference.new(:r0)
          tmp = RegisterReference.new(:r5)
          move = RegisterMachine.instance.ldr( to , tmp , code.to.index )
          block.replace(code , [move] )
        else
          raise "Start coding #{code.inspect}"
        end
      end
    end
  end
  Virtual::Object.space.add_pass_after SetImplementation , GetImplementation
end
