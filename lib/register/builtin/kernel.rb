module Register
  module Builtin
    module Kernel
      module ClassMethods
        # this is the really really first place the machine starts (apart from the jump here)
        # it isn't really a function, ie it is jumped to (not called), exits and may not return
        # so it is responsible for initial setup
        def __init__ context
          compiler = Soml::Compiler.new.create_method(:Kernel,:__init__ , [])
          # no method enter or return (automatically added), remove
          new_start = Label.new("__init__" , "__init__" )
          compiler.method.instructions = new_start
          compiler.set_current new_start

          #Set up the Space as self upon init
          space = Parfait::Space.object_space
          space_reg = Register.tmp_reg(:Space)
          compiler.add_code LoadConstant.new("__init__", space , space_reg)
          message_ind = Register.resolve_index( :space , :first_message )
          # Load the message to new message register (r1)
          compiler.add_code Register.get_slot( "__init__" , space_reg , message_ind , :new_message)
          # And store the space as the new self (so the call can move it back as self)
          compiler.add_code Register.set_slot( "__init__", space_reg , :new_message , :receiver)
          # now we are set up to issue a call to the main
          Register.issue_call( compiler , Register.machine.space.get_main)
          emit_syscall( compiler , :exit )
          return compiler.method
        end
        def exit context
          compiler = Soml::Compiler.new.create_method(:Kernel,:exit , []).init_method
          return compiler.method
          ret = RegisterMachine.instance.exit(function)
          function.set_return ret
          function
        end

        def emit_syscall compiler , name
          save_message( compiler )
          compiler.add_code Syscall.new("emit_syscall", name )
          restore_message(compiler)
        end

        # save the current message, as the syscall destroys all context
        #
        # This relies on linux to save and restore all registers
        #
        def save_message(compiler)
          r8 = RegisterValue.new( :r8 , :Message)
          compiler.add_code RegisterTransfer.new("save_message", Register.message_reg , r8 )
        end

        def restore_message(compiler)
          r8 = RegisterValue.new( :r8 , :Message)
          return_tmp = Register.tmp_reg :Integer
          # get the sys return out of the way
          compiler.add_code RegisterTransfer.new("restore_message", Register.message_reg , return_tmp )
          # load the stored message into the base RegisterMachine
          compiler.add_code RegisterTransfer.new("restore_message", r8 , Register.message_reg )
          # save the return value into the message
          compiler.add_code Register.set_slot( "restore_message" , return_tmp , :message , :return_value )
          # and "unroll" self and frame
        end
      end
      extend ClassMethods
    end
  end
end
