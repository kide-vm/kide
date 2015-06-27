module Builtin
  module Kernel
    module ClassMethods
      # this is the really really first place the machine starts (apart from the jump here)
      # it isn't really a function, ie it is jumped to (not called), exits and may not return
      # so it is responsible for initial setup
      def __init__ context
        function = Virtual::CompiledMethodInfo.create_method(:Kernel,:__init__ , [])
        function.info.return_type = Virtual::Integer
        # no method enter or return (automatically added), remove
        function.info.blocks.first.codes.pop # no Method enter
        function.info.blocks.last.codes.pop # no Method return
        #Set up the Space as self upon init
        space = Parfait::Space.object_space
        function.info.add_code Register::LoadConstant.new( space , Register::RegisterReference.self_reg)
        message_ind = space.get_layout().index_of( :next_message )
        # Load the message to message register (0)
        function.info.add_code Register::GetSlot.new( Register::RegisterReference.self_reg , message_ind , Register::RegisterReference.new_message_reg)
        # And store the space as the new self (so the call can move it back as self)
        function.info.add_code Register::SetSlot.new( Register::RegisterReference.self_reg , Register::RegisterReference.new_message_reg , Virtual::SELF_INDEX)
        # now we are set up to issue a call to the main
        function.info.add_code Virtual::MethodCall.new(Virtual.machine.space.get_main)
        emit_syscall( function , :exit )
        return function
      end
      def putstring context
        function = Virtual::CompiledMethodInfo.create_method(:Kernel , :putstring , [] )
        emit_syscall( function , :putstring )
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
        function.info.add_code Register::LoadConstant.new( Parfait::Space.object_space , space_tmp)
        function.info.add_code Register::SetSlot.new( Register::RegisterReference.message_reg , space_tmp , ind)
      end
      def restore_message(function)
        # get the sys return out of the way
        return_tmp = Register::RegisterReference.tmp_reg
        # load the space into the base register
        function.info.add_code Register::RegisterTransfer.new( return_tmp , Register::RegisterReference.message_reg )
        slot = Virtual::Slot
        # find the stored message
        ind = Parfait::Space.object_space.get_layout().index_of( :syscall_message )
        raise "index not found for #{kind}.#{kind.class}" unless ind
        # and load it into the base RegisterMachine
        function.info.add_code Register::GetSlot.new( Register::RegisterReference.message_reg , ind , Register::RegisterReference.message_reg )
        # and "unroll" self and frame
        function.info.add_code Register::GetSlot.new( Register::RegisterReference.message_reg , Virtual::SELF_INDEX, Register::RegisterReference.self_reg )
        function.info.add_code Register::GetSlot.new( Register::RegisterReference.message_reg , Virtual::FRAME_INDEX, Register::RegisterReference.frame_reg )
      end
    end
    extend ClassMethods
  end
end
