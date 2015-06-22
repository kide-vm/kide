module Builtin
  module Kernel
    module ClassMethods
      # this is the really really first place the machine starts.
      # it isn't really a function, ie it is jumped to (not called), exits and may not return
      # so it is responsible for initial setup (and relocation)
      def __init__ context
        function = Virtual::CompiledMethodInfo.create_method(:Kernel,:__init__ , [])
#        puts "INIT LAYOUT #{function.get_layout.get_layout}"
        function.info.return_type = Virtual::Integer
        main = Virtual.machine.space.get_main
        me = Virtual::Self.new(Virtual::Reference)
        code = Virtual::Set.new(me , Virtual::Self.new(me.type))
        function.info.add_code(code)
        function.info.add_code Virtual::MethodCall.new(main)
        return function
      end
      def putstring context
        function = Virtual::CompiledMethodInfo.create_method(:Kernel , :putstring , [] )
        emit_syscall( function , :putstring )
        ret = Virtual::RegisterMachine.instance.write_stdout(function)
        function.set_return ret
        function
      end
      def exit context
        function = Virtual::CompiledMethodInfo.create_method(:Kernel,:exit , [])
        function.info.return_type = Virtual::Integer
        return function
        ret = Virtual::RegisterMachine.instance.exit(function)
        function.set_return ret
        function
      end
      def __send context
        function = Virtual::CompiledMethodInfo.create_method(:Kernel ,:__send , [] )
        function.info.return_type = Virtual::Integer
        return function
      end

      private
      def emit_syscall function , name
        save_message( function )
        function.info.add_code Register::Syscall.new( name )
        restore_message(function)
      end
      # save the current message, as the syscall destroys all context
      #
      # currently HACKED into the space as a temporary varaible. As the space is a globally
      # unique object we can retrieve it from there
      # TODO : fix this to use global (later per thread) variable
      def save_message(function)
        space_tmp = Register::RegisterReference.tmp_reg
        ind = Parfait::Space.object_space.get_layout().index_of( :syscall_message )
        raise "index not found for :syscall_message" unless ind
        function.info.add_code LoadConstant.new( space_tmp , Parfait::Space.object_space )
        function.info.add_code << SetSlot.new( Virtual::Slot::MESSAGE_REGISTER , space_tmp , ind)
      end
      def restore_message(function)
        # get the sys return out of the way
        return_tmp = Register::RegisterReference.tmp_reg
        # load the space into the base register
        function.info.add_code RegisterTransfer.new( Virtual::Slot::MESSAGE_REGISTER , return_tmp )
        # find the stored message
        ind = Parfait::Space.object_space.get_layout().index_of( :syscall_message )
        raise "index not found for #{kind}.#{kind.class}" unless ind
        # and load it into the base RegisterMachine
        function.info.add_code GetSlot.new( Virtual::Slot::MESSAGE_REGISTER , ind , Virtual::Slot::MESSAGE_REGISTER )
        # and "unroll" self and frame
        function.info.add_code GetSlot.new( slot::MESSAGE_REGISTER , Virtual::SELF_INDEX, slot::SELF_REGISTER )
        function.info.add_code GetSlot.new( slot::MESSAGE_REGISTER , Virtual::FRAME_INDEX, slot::FRAME_REGISTER )
      end
    end
    extend ClassMethods
  end
end
