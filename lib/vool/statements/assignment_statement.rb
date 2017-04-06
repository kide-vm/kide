module Vool
  class Assignment < Statement
    attr_reader :name , :value
    def initialize(name , value )
      @name , @value = name , value
    end
  end
  class LocalAssignment < Assignment
  end
  class InstanceAssignment < Assignment
  end
end
