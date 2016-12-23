module Typed
  module Tree
    class WhileStatement < Statement
      attr_accessor :branch_type , :condition , :statements
      def to_s
        str = "while_#{branch_type}(#{condition}) do\n"
        str + statements.join(" ") + "\nend\n"
      end
    end
  end
end
