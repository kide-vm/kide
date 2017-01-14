module Vm
  module Tree
    class FieldAccess < Expression
      attr_accessor :receiver , :field
      def to_s
        "#{receiver}.#{field}"
      end
    end
  end
end
