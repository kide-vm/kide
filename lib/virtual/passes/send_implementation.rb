module Virtual
  # This implements the send logic
  # Send is so complicated that we actually code it in ruby and stick it in
  # That off course opens up an endless loop possibility that we stop by
  # implementing Class and Module methods

  # Note: I find it slightly unsemetrical that the NewMessage object needs to be created before this instruction
  #       This is because all expressions create a (return) value and that return value is overwritten by the next
  #       expression unless saved. And since the message is the place to save it it needs to exist. qed
  class SendImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? MessageSend
        new_codes = [  ]
        ref = code.me
        raise "only refs implemented #{me.inspect}" unless ( ref.type == Reference)
        if(ref.value)
          me = ref.value
          if( me.is_a? BootClass )
            raise "unimplemented #{code}"
          elsif( me.is_a? ObjectConstant )
            # get the function from my class. easy peasy
            method = me.clazz.get_instance_method(code.name)
            raise "Method not implemented #{clazz.name}.#{code.name}" unless method
            new_codes << Register::FunctionCall.new( method )
          else
            # note: this is the current view: call internal send, even the method name says else
            # but send is "special" and accesses the internal method name and resolves.
            kernel = Virtual::BootSpace.space.get_or_create_class(:Kernel)
            method = kernel.get_instance_method(:__send)
            new_codes << Register::FunctionCall.new( method )
            raise "unimplemented #{code}"
          end
        else
          raise "not constant/ known object for send #{ref.inspect}"
        end
        block.replace(code , new_codes )
      end
    end
  end
end
