module Vool
  class Assignment < Statement
    attr_reader :name , :value
    def initialize(name , value )
      @name , @value = name , value
    end
    def collect(arr)
      @value.collect(arr)
      super
    end
  end
  class LocalAssignment < Assignment
  end
  class InstanceAssignment < Assignment
  end
end
