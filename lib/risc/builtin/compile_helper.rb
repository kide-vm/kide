
module Risc
  module Builtin
    module CompileHelper

      def self_and_int_arg(compiler , source)
        me = compiler.add_known(  :receiver )
        int_arg = load_int_arg_at(compiler , source , 1 )
        return me , int_arg
      end

      def compiler_for( type , method_name , arguments , locals = {})
        frame = Parfait::NamedList.type_for( locals ) #TODO fix locals passing/ using in builtin
        args = Parfait::NamedList.type_for( arguments )
        Risc::MethodCompiler.create_method(type , method_name , args, frame )
      end

      # Load the value
      def load_int_arg_at(compiler, source , at)
        int_arg = compiler.use_reg :Integer
        compiler.add_slot_to_reg(source , :message , :arguments , int_arg )
        compiler.add_slot_to_reg(source , int_arg , at + 1, int_arg ) #1 for type
        return int_arg
      end

    end
  end
end
