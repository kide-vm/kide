require_relative "compile_helper"

module Register
  module Builtin
    module Word
      module ClassMethods
        include CompileHelper

        def putstring context
          compiler = Typed::Compiler.new.create_method(:Word , :putstring ).init_method
          compiler.add_code Register.get_slot( "putstring" , :message , :receiver , :new_message )
          index = Parfait::Word.get_length_index
          reg = RegisterValue.new(:r2 , :Integer)
          compiler.add_code Register.get_slot( "putstring" , :new_message , index , reg )
          Kernel.emit_syscall( compiler , :putstring )
          compiler.method
        end

        # self[index] basically. Index is the first arg > 0
        # return (and word sized int) is stored in return_value
        def get_internal_byte context
          compiler = compiler_for(:Word , :get_internal_byte)
          source = "get_internal_byte"
          me , index = self_and_arg(compiler,source)
          # reduce me to me[index]
          compiler.add_code GetByte.new( source , me , index , me)
          # and put it back into the return value
          compiler.add_code Register.set_slot( source , me , :message , :return_value)
          return compiler.method
        end

        # self[index] = val basically. Index is the first arg ( >0),
        # value the second
        # no return
        def set_internal_byte context
          compiler = compiler_for(:Word, :set_internal_byte , {:value => :Integer} )
          source = "set_internal_byte"
          me , index = self_and_arg(compiler,source)
          value = do_load(compiler,source)
          # do the set
          compiler.add_code SetByte.new( source , value , me , index)
          return compiler.method
        end

      end
      extend ClassMethods
    end
  end
end
