module Risc
  module Builtin
    class Object
      module ClassMethods
        include CompileHelper

        # self[index] basically. Index is the first arg
        # return is stored in return_value
        # (this method returns a new method off course, like all builtin)
        def get_internal_word context
          compiler = compiler_for(:Object , :get_internal_word ,{at: :Integer})
          source = "get_internal_word"
          me , index = self_and_int_arg(compiler,source)
          # reduce me to me[index]
          compiler.add_slot_to_reg( source , me , index , me)
          # and put it back into the return value
          compiler.add_reg_to_slot( source , me , :message , :return_value)
          return compiler.method
        end

        # self[index] = val basically. Index is the first arg , value the second
        # no return
        def set_internal_word context
          compiler = compiler_for(:Object , :set_internal_word , {at: :Integer, :value => :Object} )
          source = "set_internal_word"
          me , index = self_and_int_arg(compiler,source)
          value = load_int_arg_at(compiler,source , 2)

          # do the set
          compiler.add_reg_to_slot( source , value , me , index)
          return compiler.method
        end

      end
      extend ClassMethods
    end
  end
end
