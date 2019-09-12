module Mom
  class Macro < Instruction

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

require_relative "comparison"
require_relative  "exit"
require_relative "init"
require_relative	"putstring"
require_relative "set_internal_word"
require_relative "div10"
require_relative "get_internal_byte"
require_relative "method_missing"
require_relative "div4"
require_relative "get_internal_word"
require_relative "operator"
require_relative "set_internal_byte"
