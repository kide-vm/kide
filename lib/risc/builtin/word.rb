require_relative "compile_helper"

module Risc
  module Builtin
    module Word
      module ClassMethods
        include CompileHelper

        def putstring context
          compiler = Vm::MethodCompiler.create_method(:Word , :putstring ).init_method
          compiler.add_slot_to_reg( "putstring" , :message , :receiver , :new_message )
          index = Parfait::Word.get_length_index
          reg = RiscValue.new(:r2 , :Integer)
          compiler.add_slot_to_reg( "putstring" , :new_message , index , reg )
          Kernel.emit_syscall( compiler , :putstring )
          compiler.method
        end

        # self[index] basically. Index is the first arg > 0
        # return (and word sized int) is stored in return_value
        def get_internal_byte context
          compiler = compiler_for(:Word , :get_internal_byte)
          source = "get_internal_byte"
          me , index = self_and_int_arg(compiler,source)
          # reduce me to me[index]
          compiler.add_byte_to_reg( source , me , index , me)
          # and put it back into the return value
          compiler.add_reg_to_slot( source , me , :message , :return_value)
          return compiler.method
        end

        # self[index] = val basically. Index is the first arg ( >0),
        # value the second
        # no return
        def set_internal_byte context
          compiler = compiler_for(:Word, :set_internal_byte , {:value => :Integer} )
          args = compiler.method.arguments
          len = args.instance_length
          raise "Compiler arg number mismatch, method=#{args} " if  len != 3
          source = "set_internal_byte"
          me , index = self_and_int_arg(compiler,source)
          value = load_int_arg_at(compiler , source , 2 )
          # do the set
          compiler.add_reg_to_byte( source , value , me , index)
          return compiler.method
        end

      end
      extend ClassMethods
    end
  end
end
