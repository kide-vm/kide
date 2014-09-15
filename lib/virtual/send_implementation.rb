module Virtual
  # This implements the send logic
  # Send is so complicated that we actually code it in ruby and stick it in
  # That off course opens up an endless loop possibility that we stop by reducing to Class and Module methods
  class SendImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? MessageSend
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
            call = FunctionCall.new( method )
            block.replace(code , call )
          else
            raise "unimplemented #{code}"
          end
        else
          raise "not constant/ known object for send #{me.inspect}"
        end
      end
    end
  end
end
