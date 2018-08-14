module Risc
  module Builtin
    class Object
      module ClassMethods
        include CompileHelper

        # self[index] basically. Index is the first arg
        # return is stored in return_value
        def get_internal_word( context )
          compiler = compiler_for(:Object , :get_internal_word ,{at: :Integer})
          compiler.compiler_builder(compiler.source).build do
            object! << message[:receiver]
            integer! << message[:arguments]
            integer << integer[1]
            integer.reduce_int
            object << object[integer]
            message[:return_value] << object
          end
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler
        end

        # self[index] = val basically. Index is the first arg , value the second
        # return the value passed in
        def set_internal_word( context )
          compiler = compiler_for(:Object , :set_internal_word , {at: :Integer, :value => :Object} )
          compiler.compiler_builder(compiler.source).build do
            object! << message[:receiver]
            integer! << message[:arguments]
            object_reg! << integer[ 2]
            integer << integer[1]
            integer.reduce_int
            object[integer] << object_reg
            message[:return_value] << object_reg
          end
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler
        end

        # every object needs a method missing.
        # Even if it's just this one, sys_exit (later raise)
        def _method_missing( context )
          compiler = compiler_for(:Object,:method_missing ,{})
          emit_syscall( compiler.compiler_builder(compiler.source) , :exit )
          return compiler
        end

        # this is the really really first place the machine starts (apart from the jump here)
        # it isn't really a function, ie it is jumped to (not called), exits and may not return
        # so it is responsible for initial setup:
        # - load fist message, set up Space as receiver
        # - call main, ie set up message for that etc
        # - exit (exit_sequence) which passes a machine int out to c
        def __init__( context )
          compiler = MethodCompiler.compiler_for_class(:Object,:__init__ ,
                            Parfait::NamedList.type_for({}) , Parfait::NamedList.type_for({}))
          builder = compiler.compiler_builder(compiler.source)
          builder.build do
            space! << Parfait.object_space
            message << space[:next_message]
            next_message! << message[:next_message]
            space[:next_message] << next_message
          end

          Mom::MessageSetup.new(Parfait.object_space.get_main).build_with( builder )

          builder.build do
            message << message[:next_message]
            message[:receiver] << space
          end

          exit_label = Risc.label(compiler.source , "#{compiler.receiver_type.object_class.name}.#{compiler.source.name}" )
          ret_tmp = compiler.use_reg(:Label)
          builder.build do
            add_load_constant("__init__ load return", exit_label , ret_tmp)
            add_reg_to_slot("__init__ store return", ret_tmp , Risc.message_reg , :return_address)
            add_function_call( "__init__ issue call" ,  Parfait.object_space.get_main)
            add_code exit_label
          end
          compiler.reset_regs
          exit_sequence(builder)
          return compiler
        end

        # a sort of inline version of exit method.
        # Used by exit and __init__ (so it doesn't have to call it)
        # Assumes int return value and extracts the fixnum for process exit code
        def exit_sequence(builder)
          save_message( builder )
          message = Risc.message_reg
          builder.add_slot_to_reg "get return" , message , :return_value , message
          builder.add_slot_to_reg( "reduce return" , message , Parfait::Integer.integer_index , message)
          builder.add_code Syscall.new("emit_syscall(exit)", :exit )
        end

        # the exit function
        # mainly calls exit_sequence
        def exit( context )
          compiler = compiler_for(:Object,:exit ,{})
          builder = compiler.compiler_builder(compiler.source)
          exit_sequence(builder)
          return compiler
        end

        # emit the syscall with given name
        # there is a Syscall instruction, but the message has to be saved and restored
        def emit_syscall( builder , name )
          save_message( builder )
          builder.add_code Syscall.new("emit_syscall(#{name})", name )
          restore_message(builder)
          return unless (@clazz and @method)
          builder.add_code Risc.label( "#{@clazz.name}.#{@message.name}" , "return_syscall" )
        end

        # save the current message, as the syscall destroys all context
        #
        # This relies on linux to save and restore all registers
        #
        def save_message(builder)
          r8 = RegisterValue.new( :r8 , :Message)
          builder.add_transfer("save_message", Risc.message_reg , r8 )
        end

        # restore the message that we save in r8
        # get a new int and save the c return into it
        # tht int gets retured, ie is the return_value of the message
        def restore_message(builder)
          r8 = RegisterValue.new( :r8 , :Message)
          int = builder.compiler.use_reg(:Integer)
          builder.build do
            integer_reg! << message
            message << r8
            add_new_int( "_restore_message", integer_reg , int )
            message[:return_value] << int
          end
        end

      end
      extend ClassMethods
    end
  end
end
