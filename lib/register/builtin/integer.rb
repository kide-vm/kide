#integer related kernel functions
module Register
  module Builtin
    module Integer
      module ClassMethods
        include AST::Sexp

        def mod4 context
          compiler = Soml::Compiler.new.create_method(:Integer,:mod4 ).init_method
          return compiler.method
        end
        def putint context
          compiler = Soml::Compiler.new.create_method(:Integer,:putint ).init_method
          return compiler.method
        end

      end
      extend ClassMethods
    end
  end
end
