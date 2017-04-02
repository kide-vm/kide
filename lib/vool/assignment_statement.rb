module Vool
  class Assignment < Statement
    attr_accessor :name , :value
    def initialize(name , value )
      @name , @value = name , value
    end
  end
  class LocalAssignment < Assignment
  end
  
end
