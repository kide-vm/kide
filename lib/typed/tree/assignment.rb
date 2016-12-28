module Typed
  module Tree
    class Assignment < Statement
      attr_accessor :name , :value
      def initialize(n = nil , v = nil )
        @name , @value = n , v
      end
      def to_s
        "#{name} = #{value}\n"
      end
    end
  end
end
