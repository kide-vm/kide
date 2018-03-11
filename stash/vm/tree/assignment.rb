module Vm
  module Tree

    class Assignment < Statement
      attr_accessor :name , :value

      def initialize(name  , value = nil )
        @name , @value = name , value
      end

      def to_s
        "#{name} = #{value}\n"
      end

    end

    class IvarAssignment < Assignment
      def to_s
        "@#{name} = #{value}\n"
      end
    end

    class ArgAssignment < Assignment
    end

    class LocalAssignment < Assignment
    end

  end
end
