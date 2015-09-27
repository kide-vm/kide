module Bosl
  Compiler.class_eval do

    def on_call expression
      name , arguments , receiver = *expression
      name = name.to_a.first

      if receiver
        me = process( receiver.to_a.first  )
      else
        me = Virtual::Self.new :int
      end
      ## need two step process, compile and save to frame
      # then move from frame to new message
      method.source.add_code Virtual::NewMessage.new
      method.source.add_code Virtual::Set.new( me , Virtual::NewSelf.new(me.type))
      method.source.add_code Virtual::Set.new( name.to_sym , Virtual::NewMessageName.new(:int))
      compiled_args = []
      arguments.to_a.each_with_index do |arg , i|
        #compile in the running method, ie before passing control
        val = process( arg)
        # move the compiled value to it's slot in the new message
        # + 1 as this is a ruby 0-start , but 0 is the last message ivar.
        # so the next free is +1
        to = Virtual::NewArgSlot.new(i + 1 ,val.type , val)
        # (doing this immediately, not after the loop, so if it's a return it won't get overwritten)
        method.source.add_code Virtual::Set.new( val , to )
        compiled_args << to
      end
      #method.source.add_code Virtual::MessageSend.new(name , me , compiled_args) #and pass control
      method = nil
      if(me.value)
        me = me.value
        if( me.is_a? Parfait::Class )
          raise "unimplemented #{code}  me is #{me}"
        elsif( me.is_a? Symbol )
          # get the function from my class. easy peasy
          method = Virtual.machine.space.get_class_by_name(:Word).get_instance_method(name)
          raise "Method not implemented #{me.class}.#{code.name}" unless method
          @method.source.add_code Virtual::MethodCall.new( method )
        elsif( me.is_a? Fixnum )
          name = :plus if name == :+
          method = Virtual.machine.space.get_class_by_name(:Integer).get_instance_method(name)
          #puts Virtual.machine.space.get_class_by_name(:Integer).method_names.to_a
          raise "Method not implemented Integer.#{name}" unless method
          @method.source.add_code Virtual::MethodCall.new( method )
        else
          # note: this is the current view: call internal send, even the method name says else
          # but send is "special" and accesses the internal method name and resolves.
          kernel = Virtual.machine.space.get_class_by_name(:Kernel)
          method = kernel.get_instance_method(:__send)
          @method.source.add_code Virtual::MethodCall.new( method )
          raise "unimplemented: \n#{code} \nfor #{ref.inspect}"
        end
      else
        method = @method
        @method.source.add_code Virtual::MethodCall.new( @method )
      end
      raise "Method not implemented #{me.value}.#{name}" unless method
      # the effect of the method is that the NewMessage Return slot will be filled, return it
      # (this is what is moved _inside_ above loop for such expressions that are calls (or constants))
      Virtual::Return.new( method.source.return_type )
    end
  end
end
