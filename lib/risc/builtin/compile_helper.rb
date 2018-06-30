
module Risc
  module Builtin
    module CompileHelper

      def compiler_for( clazz_name , method_name , arguments , locals = {})
        frame = Parfait::NamedList.type_for( locals )
        args = Parfait::NamedList.type_for( arguments )
        RiscCompiler.compiler_for_class(clazz_name , method_name , args, frame )
      end

    end
  end
end
