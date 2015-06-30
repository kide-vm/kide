module Register
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
          function.info.add_code LoadConstant.new( space , Register.self_reg)
          message_ind = space.get_layout().index_of( :init_message )
          # Load the message to new message register (r3)
          function.info.add_code Register.get_slot( :self , message_ind , :new_message)
          # And store the space as the new self (so the call can move it back as self)
          function.info.add_code Register.set_slot( :self , :new_message , :receiver)
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
          function.info.add_code Syscall.new( name )
          restore_message(function)
        end
        # save the current message, as the syscall destroys all context
        #
        # currently HACKED into the space as a temporary varaible. As the space is a globally
        # unique object we can retrieve it from there
        # TODO : fix this to use global (later per thread) variable
        def save_message(function)
          space_tmp = Register.tmp_reg
          ind = Register.resolve_index( :space , :syscall_message )
          function.info.add_code LoadConstant.new( Parfait::Space.object_space , space_tmp)
          function.info.add_code SetSlot.new( Register.message_reg , space_tmp , ind)
        end

        def restore_message(function)
          # get the sys return out of the way
          return_tmp = Register.tmp_reg
          function.info.add_code RegisterTransfer.new( Register.message_reg , return_tmp )
          # load the space into the base register
          function.info.add_code LoadConstant.new(Parfait::Space.object_space ,Register.message_reg)
          # find the stored message
          ind = Register.resolve_index( :space , :syscall_message )
          # and load it into the base RegisterMachine
          function.info.add_code Register.get_slot :message , ind , :message
          # save the return value into the message
          function.info.add_code Register.set_slot( return_tmp , :message , :return_value )
          # and "unroll" self and frame
          function.info.add_code Register.get_slot(:message , :receiver, :self )
          function.info.add_code Register.get_slot(:message , :frame , :frame)
        end
      end
      extend ClassMethods
    end
  end
end
