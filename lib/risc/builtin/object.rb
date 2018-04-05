module Risc
  module Builtin
    class Object
      module ClassMethods
        include CompileHelper

        # self[index] basically. Index is the first arg
        # return is stored in return_value
        # (this method returns a new method off course, like all builtin)
        def get_internal_word( context )
          compiler = compiler_for(:Object , :get_internal_word ,{at: :Integer})
          source = "get_internal_word"
          me , index = compiler.self_and_int_arg(source)
          # reduce me to me[index]
          compiler.add_slot_to_reg( source , me , index , me)
          # and put it back into the return value
          compiler.add_reg_to_slot( source , me , :message , :return_value)
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler.method
        end

        # self[index] = val basically. Index is the first arg , value the second
        # no return
        def set_internal_word( context )
          compiler = compiler_for(:Object , :set_internal_word , {at: :Integer, :value => :Object} )
          source = "set_internal_word"
          me , index = compiler.self_and_int_arg(source)
          value = compiler.load_int_arg_at(source , 2)

          # do the set
          compiler.add_reg_to_slot( source , value , me , index)
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler.method
        end

        # every object needs a method missing.
        # Even if it's just this one, sys_exit (later raise)
        def _method_missing( context )
          compiler = compiler_for(:Object,:method_missing ,{})
          emit_syscall( compiler , :exit )
          return compiler.method
        end
        # this is the really really first place the machine starts (apart from the jump here)
        # it isn't really a function, ie it is jumped to (not called), exits and may not return
        # so it is responsible for initial setup
        def __init__ context
          compiler = Risc::MethodCompiler.create_method(:Object,:__init__ ,
                            Parfait::NamedList.type_for({}) , Parfait::NamedList.type_for({}))
          space_reg = compiler.use_reg(:Space) #Set up the Space as self upon init
          compiler.add_load_constant("__init__ load Space", Parfait.object_space , space_reg)
          message_ind = Risc.resolve_to_index( :Space , :first_message )
          #load the first_message (instance of space)
          compiler.add_slot_to_reg( "__init__ load 1st message" , space_reg , message_ind , :message)
          compiler.add_mom( Mom::MessageSetup.new(Parfait.object_space.get_main))
          # but use it's next message, so main can return normally
          compiler.add_slot_to_reg( "__init__ load 2nd message" , :message , :next_message , :message)
          compiler.add_load_constant("__init__ load Space", Parfait.object_space , space_reg)
          compiler.add_reg_to_slot( "__init__ store Space in message", space_reg , :message , :receiver)
          #fixme: should add arg type here, as done in call_site (which this sort of is)
          exit_label = Risc.label("_exit_label for __init__" , "#{compiler.type.object_class.name}.#{compiler.method.name}" )
          ret_tmp = compiler.use_reg(:Label)
          compiler.add_load_constant("__init__ load return", exit_label , ret_tmp)
          compiler.add_reg_to_slot("__init__ store return", ret_tmp , :message , :return_address)
          compiler.add_function_call( "__init__ issue call" ,  Parfait.object_space.get_main , ret_tmp)
          compiler.add_code exit_label
          emit_syscall( compiler , :exit )
          return compiler.method
        end

        def exit( context )
          compiler = compiler_for(:Object,:exit ,{})
          emit_syscall( compiler , :exit )
          return compiler.method
        end

        def emit_syscall( compiler , name )
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
          return_tmp = compiler.use_reg :fixnum
          source = "_restore_message"
          # get the sys return out of the way
          compiler.add_transfer(source, Risc.message_reg , return_tmp )
          # load the stored message into the base register
          compiler.add_transfer(source, r8 , Risc.message_reg )
          int = compiler.use_reg(:Integer)
          compiler.add_new_int(source , return_tmp , int )
          # save the return value into the message
          compiler.add_reg_to_slot( source , int , :message , :return_value )
        end

      end
      extend ClassMethods
    end
  end
end
