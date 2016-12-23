module Typed
  module Tree
    class ReturnStatement < Statement
      attr_accessor :return_value

      def to_s
        "return #{return_value}"
      end
    end
  end
end
