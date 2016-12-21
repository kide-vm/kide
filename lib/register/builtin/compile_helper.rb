
module Register
  module Builtin
    module CompileHelper

      def self_and_int_arg(compiler , source)
        #Load self by "calling" on_name
        me = compiler.process( Typed::Tree::NameExpression.new( :self) )
        # Load the argument
        index = compiler.use_reg :Integer
        compiler.add_code Register.get_slot(source , :message , 1 , index )
        return me , index
      end

      def compiler_for( type , method_name , extra_args = {})
        args = {:index => :Integer}.merge( extra_args )
        Typed::MethodCompiler.new.create_method(type , method_name , args ).init_method
      end

      # Load the value
      def load_arg_at(compiler, source , at)
        value = compiler.use_reg :Integer
        compiler.add_code Register.get_slot(source , :message , at , value )
        value
      end

    end
  end
end
