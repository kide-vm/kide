module Trickle
  # This implements the send logic
  # Send is so complicated that we actually code it in ruby and stick it in
  # That off course opens up an endless loop possibility that we stop by reducing to Class and Module methods
  class Send
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MessageSend
        me = code.me
        next unless ( me.type == Virtual::Reference)
        if( me.is_a? Virtual::Constant)
          Boot::BootClass
          if( me.is_a? Boot::BootClass )
            raise "unimplemented"
          elsif( me.is_a? Virtual::ObjectConstant )
            clazz = me.clazz
            method = clazz.get_method_definition code.name
            raise "Method not implemented #{clazz.name}.#{code.name}" unless method
            call = Virtual::FunctionCall.new( method )
            block.replace(code , [call] )
          else
            raise "unimplemented"
          end
        end
      end
    end
  end
end
