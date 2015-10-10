module Register
  module Builtin
    module Kernel
      module ClassMethods
        # this is the really really first place the machine starts (apart from the jump here)
        # it isn't really a function, ie it is jumped to (not called), exits and may not return
        # so it is responsible for initial setup
        def __init__ context
          function = Virtual::MethodSource.create_method(:Kernel,:int,:__init__ , [])
          function.source.return_type = Phisol::Type.int
          # no method enter or return (automatically added), remove
          function.source.blocks.first.codes.pop # no Method enter
          function.source.blocks.last.codes.pop # no Method return
          #Set up the Space as self upon init
          space = Parfait::Space.object_space
          function.source.add_code LoadConstant.new(function, space , Register.self_reg)
          message_ind = Register.resolve_index( :space , :first_message )
          # Load the message to new message register (r3)
          function.source.add_code Register.get_slot( function , :self , message_ind , :new_message)
          # And store the space as the new self (so the call can move it back as self)
          function.source.add_code Register.set_slot( function, :self , :new_message , :receiver)
          # now we are set up to issue a call to the main
          function.source.add_code Virtual::MethodCall.new(Virtual.machine.space.get_main)
          emit_syscall( function , :exit )
          return function
        end
        def exit context
          function = Virtual::MethodSource.create_method(:Kernel,:int,:exit , [])
          function.source.return_type = Phisol::Type.int
          return function
          ret = Virtual::RegisterMachine.instance.exit(function)
          function.set_return ret
          function
        end
        def __send context
          function = Virtual::MethodSource.create_method(:Kernel,:int ,:__send , [] )
          function.source.return_type = Phisol::Type.int
          return function
        end

        def emit_syscall function , name
          save_message( function )
          function.source.add_code Syscall.new(function, name )
          restore_message(function)
        end

        # save the current message, as the syscall destroys all context
        #
        # This relies on linux to save and restore all registers
        #
        def save_message(function)
          function.source.add_code RegisterTransfer.new(function, Register.message_reg , :r8 )
        end

        def restore_message(function)
          return_tmp = Register.tmp_reg function.source.return_type
          # get the sys return out of the way
          function.source.add_code RegisterTransfer.new(function, Register.message_reg , return_tmp )
          # load the stored message into the base RegisterMachine
          function.source.add_code RegisterTransfer.new(function, :r8 , Register.message_reg )
          # save the return value into the message
          function.source.add_code Register.set_slot( function, return_tmp , :message , :return_value )
          # and "unroll" self and frame
          function.source.add_code Register.get_slot(function, :message , :receiver, :self )
          function.source.add_code Register.get_slot(function, :message , :frame , :frame)
        end
      end
      extend ClassMethods
    end
  end
end
