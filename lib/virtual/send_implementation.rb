module Virtual
  # This implements the send logic
  # Send is so complicated that we actually code it in ruby and stick it in
  # That off course opens up an endless loop possibility that we stop by reducing to Class and Module methods
  class SendImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? MessageSend
        me = code.me
        next unless ( me.type == Reference)
        if( me.is_a? Constant)
          if( me.is_a? BootClass )
            raise "unimplemented"
          elsif( me.is_a? ObjectConstant )
            clazz = me.clazz
            method = clazz.get_instance_method code.name
            raise "Method not implemented #{clazz.name}.#{code.name}" unless method
            call = FunctionCall.new( method )
            block.replace(code , call )
          else
            raise "unimplemented"
          end
        end
      end
    end
  end
end
