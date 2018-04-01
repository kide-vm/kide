
module Risc
  module Builtin
    module CompileHelper

      def compiler_for( type , method_name , arguments , locals = {})
        frame = Parfait::NamedList.type_for( locals ) #TODO fix locals passing/ using in builtin
        args = Parfait::NamedList.type_for( arguments )
        Risc::MethodCompiler.create_method(type , method_name , args, frame )
      end

    end
  end
end
