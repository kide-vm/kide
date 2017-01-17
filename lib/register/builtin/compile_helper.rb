
module Register
  module Builtin
    module CompileHelper

      def self_and_int_arg(compiler , source)
        me = compiler.process( Vm::Tree::KnownName.new( :self) )
        int_arg = load_int_arg_at(compiler , source , 1 )
        return me , int_arg
      end

      def compiler_for( type , method_name , extra_args = {})
        args = {:index => :Integer}.merge( extra_args )
        Vm::MethodCompiler.create_method(type , method_name , args ).init_method
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
