module Virtual
  # This implements the send logic
  # Send is so complicated that we actually code it in ruby and stick it in
  # That off course opens up an endless loop possibility that we stop by reducing to Class and Module methods
  class SetImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::Set
        if( code.to.is_a? NewMessageSlot)
          to = RegisterReference.new(:r0)
          tmp = RegisterReference.new(:r5)
          move = RegisterMachine.mov( to , tmp , code.index )
        else
          raise "Start coding #{code.inspect}"
        end
      end
    end
  end
  Object.space.add_pass_after SetImplementation , GetImplementation
end
