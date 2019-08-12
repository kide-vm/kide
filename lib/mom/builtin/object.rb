require_relative "get_internal_word"
require_relative "set_internal_word"
require_relative "method_missing"
require_relative "init"
require_relative "exit"

module Mom
  module Builtin
    class Object
      module ClassMethods
        include CompileHelper

        # self[index] basically. Index is the first arg
        # return is stored in return_value
        def get_internal_word( context )
          compiler = compiler_for(:Object , :get_internal_word ,{at: :Integer})
          compiler.add_code GetInternalWord.new("get_internal_word")
          return compiler
        end
        # self[index] = val basically. Index is the first arg , value the second
        # return the value passed in
        def set_internal_word( context )
          compiler = compiler_for(:Object , :set_internal_word , {at: :Integer, value: :Object} )
          compiler.add_code SetInternalWord.new("set_internal_word")
          return compiler
        end

        # every object needs a method missing.
        # Even if it's just this one, sys_exit (later raise)
        def _method_missing( context )
          compiler = compiler_for(:Object,:method_missing ,{})
          compiler.add_code MethodMissing.new("missing")
          return compiler
        end

        # this is the really really first place the machine starts (apart from the jump here)
        # it isn't really a function, ie it is jumped to (not called), exits and may not return
        # so it is responsible for initial setup:
        # - load fist message, set up Space as receiver
        # - call main, ie set up message for that etc
        # - exit (exit_sequence) which passes a machine int out to c
        def __init__( context )
          compiler = Mom::MethodCompiler.compiler_for_class(:Object,:__init__ ,
                            Parfait::NamedList.type_for({}) , Parfait::NamedList.type_for({}))
                            compiler.add_code MethodMissing.new("missing")
          return compiler
        end

        # the exit function
        # mainly calls exit_sequence
        def exit( context )
          compiler = compiler_for(:Object,:exit ,{})
          compiler.add_code Exit.new("exit")
          return compiler
        end

      end
      extend ClassMethods
    end

    # emit the syscall with given name
    # there is a Syscall instruction, but the message has to be saved and restored
    def self.emit_syscall( builder , name )
      save_message( builder )
      builder.add_code Risc::Syscall.new("emit_syscall(#{name})", name )
      restore_message(builder)
      return unless (@clazz and @method)
      builder.add_code Risc.label( "#{@clazz.name}.#{@message.name}" , "return_syscall" )
    end

    # a sort of inline version of exit method.
    # Used by exit and __init__ (so it doesn't have to call it)
    # Assumes int return value and extracts the fixnum for process exit code
    def self.exit_sequence(builder)
      save_message( builder )
      builder.build do
        message << message[:return_value]
        message.reduce_int
        add_code Risc::Syscall.new("emit_syscall(exit)", :exit )
      end
    end

    # save the current message, as the syscall destroys all context
    #
    # This relies on linux to save and restore all registers
    #
    def self.save_message(builder)
      r8 = Risc::RegisterValue.new( :r8 , :Message).set_builder(builder)
      builder.build {r8 << message}
    end

    # restore the message that we save in r8
    # before th restore, the syscall return, a fixnum, is saved
    # The caller of this method is assumed to caal prepare_int_return
    # so that the return value already has an integer instance
    # This instance is filled with os return value
    def self.restore_message(builder)
      r8 = Risc::RegisterValue.new( :r8 , :Message)
      builder.build do
        integer_reg! << message
        message << r8
        integer_2! << message[:return_value]
        integer_2[Parfait::Integer.integer_index] << integer_reg
      end
    end
  end
end
