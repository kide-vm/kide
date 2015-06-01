module Virtual
  # This implements the send logic
  # Send is so complicated that we actually code it in ruby and stick it in
  # That off course opens up an endless loop possibility that we stop by
  # implementing Class and Module methods

  # Note: I find it slightly unsymmetrical that the NewMessage object needs to be created
  #       before this instruction.
  #       This is because all expressions create a (return) value and that return value is
  #       overwritten by the next expression unless saved.
  #       And since the message is the place to save it it needs to exist. qed
  class SendImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? MessageSend
        new_codes = [  ]
        ref = code.me
        raise "only refs implemented #{ref.type}" unless ( ref.type.is_a? Reference)
        # value known at compile time, got do something with it
        if(ref.value)
          me = ref.value
          if( me.is_a? Parfait::Class )
            raise "unimplemented #{code}"
          elsif( me.is_a? Parfait::Object )
            # get the function from my class. easy peasy
            puts "Me is #{me.class}"
            method = me.get_class.get_instance_method(code.name)
            raise "Method not implemented #{me.class}.#{code.name}" unless method
            new_codes << MethodCall.new( method )
          else
            # note: this is the current view: call internal send, even the method name says else
            # but send is "special" and accesses the internal method name and resolves.
            kernel = Virtual.machine.space.get_class_by_name("Kernel")
            method = kernel.get_instance_method(:__send)
            new_codes << MethodCall.new( method )
            raise "unimplemented: \n#{code}"
          end
        else
          if ref.type.is_a?(Reference) and ref.type.of_class
            #find method and call
            clazz = ref.type.of_class
            begin
            method = clazz.resolve_method code.name
            rescue
            raise "No method found #{code.name} for #{clazz.name} in #{clazz.method_names}" unless method
            end
            new_codes << MethodCall.new( method )
          else
            # must defer send to run-time
            # So inlining the code from message.send (in the future)
            raise "not constant/ known object for send #{ref.inspect}"
          end
        end
        block.replace(code , new_codes )
      end
    end
  end
end
