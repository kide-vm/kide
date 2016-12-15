
module Register
  module Builtin
    module CompileHelper

      def self_and_arg(compiler , source)
        #Load self by "calling" on_name
        me = compiler.process( Typed::Tree::NameExpression.new( :self) )
        # Load the argument
        index = compiler.use_reg :Integer
        compiler.add_code Register.get_slot(source , :message , Parfait::Message.get_indexed(1), index )
        return me , index
      end

      def compiler_for( method_name , args)
        Typed::Compiler.new.create_method(:Object , method_name , args ).init_method
      end

      # Load the value
      def do_load(compiler, source)
        value = compiler.use_reg :Integer
        compiler.add_code Register.get_slot(source , :message , Parfait::Message.get_indexed(2), value )
        value
      end

    end
  end
end
