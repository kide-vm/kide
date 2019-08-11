module Risc
  module Builtin
    class Space
      module ClassMethods
        include CompileHelper

        # main entry point, ie __init__ calls this
        # defined here as empty, to be redefined
        def main(context)
          compiler = compiler_for(:Space , :main ,{args: :Integer})
          return compiler
        end

      end
      extend ClassMethods
    end
  end
end
