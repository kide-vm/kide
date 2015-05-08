module Virtual
  module Compiler
  # operators are really function calls

#    call_site - attr_reader  :name, :args , :receiver

    def self.compile_callsite expession , method
      me = Compiler.compile( expession.receiver , method )
      method.add_code Virtual::NewMessage.new
      method.add_code Virtual::Set.new(Virtual::NewSelf.new(me.type), me)
      method.add_code Virtual::Set.new(Virtual::NewName.new(), Virtual::StringConstant.new(expession.name))
      compiled_args = []
      expession.args.each_with_index do |arg , i|
        #compile in the running method, ie before passing control
        val = Compiler.compile( arg , method)
        # move the compiled value to it's slot in the new message
        to = Virtual::NewMessageSlot.new(i ,val.type , val)
        # (doing this immediately, not after the loop, so if it's a return it won't get overwritten)
        method.add_code Virtual::Set.new(to , val )
        compiled_args << to
      end
      method.add_code Virtual::MessageSend.new(expession.name , me , compiled_args) #and pass control
      # the effect of the method is that the NewMessage Return slot will be filled, return it
      # (this is what is moved _inside_ above loop for such expressions that are calls (or constants))
      Virtual::Return.new( method.return_type )
    end
  end
end
