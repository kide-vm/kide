module Vm
  module Tree
    class IfStatement < Statement
      attr_accessor :branch_type , :condition , :if_true , :if_false
      def to_s
        str = "if_#{branch_type}(#{condition}) \n  #{if_true}\n"
        str += "else\n  #{if_false}\n" if if_false
        str + "end\n"
      end
    end
  end
end
