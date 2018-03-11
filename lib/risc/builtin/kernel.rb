module Risc
  module Builtin
    module Kernel
      module ClassMethods
        # this is the really really first place the machine starts (apart from the jump here)
        # it isn't really a function, ie it is jumped to (not called), exits and may not return
        # so it is responsible for initial setup
        def __init__ context
          compiler = Risc::MethodCompiler.create_method(:Kernel,:__init__ )
          new_start = Risc.label("__init__ start" , "__init__" )
          compiler.method.set_instructions( new_start)
          compiler.set_current new_start

          space = Parfait.object_space
          space_reg = compiler.use_reg(:Space) #Set up the Space as self upon init
          compiler.add_load_constant("__init__ load Space", space , space_reg)
          message_ind = Risc.resolve_to_index( :space , :first_message )
          compiler.add_slot_to_reg( "__init__ load 1st message" , space_reg , message_ind , :message)
          compiler.add_reg_to_slot( "__init__ store Space in message", space_reg , :message , :receiver)
          #fixme: should add arg type here, as done in call_site (which this sort of is)
          exit_label = Risc.label("_exit_label for __init__" , "#{compiler.type.object_class.name}.#{compiler.method.name}" )
          ret_tmp = compiler.use_reg(:Label)
          compiler.add_load_constant("__init__ load return", exit_label , ret_tmp)
          compiler.add_reg_to_slot("__init__ store return", ret_tmp , :message , :return_address)
          compiler.add_code Risc.function_call( "__init__ issue call" ,  Parfait.object_space.get_main )
          compiler.add_code exit_label
          emit_syscall( compiler , :exit )
          return compiler.method
        end

        def exit context
          compiler = Risc::MethodCompiler.create_method(:Kernel,:exit ).init_method
          emit_syscall( compiler , :exit )
          return compiler.method
        end

        def emit_syscall compiler , name
          save_message( compiler )
          compiler.add_code Syscall.new("emit_syscall(#{name})", name )
          restore_message(compiler)
          return unless (@clazz and @method)
          compiler.add_label( "#{@clazz.name}.#{@message.name}" , "return_syscall" )
        end

        # save the current message, as the syscall destroys all context
        #
        # This relies on linux to save and restore all registers
        #
        def save_message(compiler)
          r8 = RiscValue.new( :r8 , :Message)
          compiler.add_transfer("save_message", Risc.message_reg , r8 )
        end

        def restore_message(compiler)
          r8 = RiscValue.new( :r8 , :Message)
          return_tmp = Risc.tmp_reg :Integer
          source = "_restore_message"
          # get the sys return out of the way
          compiler.add_transfer(source, Risc.message_reg , return_tmp )
          # load the stored message into the base RiscMachine
          compiler.add_transfer(source, r8 , Risc.message_reg )
          # save the return value into the message
          compiler.add_reg_to_slot( source , return_tmp , :message , :return_value )
        end
      end
      extend ClassMethods
    end
  end
end
