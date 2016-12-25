module Register
  module Builtin
    module Kernel
      module ClassMethods
        # this is the really really first place the machine starts (apart from the jump here)
        # it isn't really a function, ie it is jumped to (not called), exits and may not return
        # so it is responsible for initial setup
        def __init__ context
          source = "__init__"
          compiler = Typed::MethodCompiler.new.create_method(:Kernel,:__init__ )
          # no method enter or return (automatically added), remove
          new_start = Label.new(source , source )
          compiler.method.instructions = new_start
          compiler.set_current new_start

          #Set up the Space as self upon init
          space = Parfait::Space.object_space
          space_reg = compiler.use_reg(:Space)
          compiler.add_code LoadConstant.new(source, space , space_reg)
          message_ind = Register.resolve_index( :space , :first_message )
          # Load the message to new message register (r1)
          compiler.add_code Register.get_slot( source , space_reg , message_ind , :message)
          # And store the space as the new self (so the call can move it back as self)
          compiler.add_code Register.reg_to_slot( source, space_reg , :message , :receiver)
          exit_label = Label.new("_exit_label" , "#{compiler.type.object_class.name}.#{compiler.method.name}" )
          ret_tmp = compiler.use_reg(:Label)
          compiler.add_code Register::LoadConstant.new(source, exit_label , ret_tmp)
          compiler.add_code Register.reg_to_slot(source, ret_tmp , :message , :return_address)
          # do the register call
          compiler.add_code FunctionCall.new( source ,  Register.machine.space.get_main )
          compiler.add_code exit_label
          emit_syscall( compiler , :exit )
          return compiler.method
        end

        def exit context
          compiler = Typed::MethodCompiler.new.create_method(:Kernel,:exit ).init_method
          emit_syscall( compiler , :exit )
          return compiler.method
        end

        def emit_syscall compiler , name
          save_message( compiler )
          compiler.add_code Syscall.new("emit_syscall(#{name})", name )
          restore_message(compiler)
          return unless (@clazz and @method)
          compiler.add_code Label.new( "#{@clazz.name}.#{@message.name}" , "return_syscall" )
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
          source = "_restore_message"
          # get the sys return out of the way
          compiler.add_code RegisterTransfer.new(source, Register.message_reg , return_tmp )
          # load the stored message into the base RegisterMachine
          compiler.add_code RegisterTransfer.new(source, r8 , Register.message_reg )
          # save the return value into the message
          compiler.add_code Register.reg_to_slot( source , return_tmp , :message , :return_value )
        end
      end
      extend ClassMethods
    end
  end
end
