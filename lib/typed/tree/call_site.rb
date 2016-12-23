module Typed
  module Tree
    class CallSite < Expression
      attr_accessor :name , :receiver , :arguments

      def to_s
        str = receiver ? "#{receiver}.#{name}" : name.to_s
        str + arguments.collect{|a| a.to_s }.join(",")
      end
    end
  end
end
