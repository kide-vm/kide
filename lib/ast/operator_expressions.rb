module Ast
  
  # assignment, like operators are really function calls
  
  class FuncallExpression < Expression
    attr_reader  :name, :args
    def initialize name, args
      @name , @args = name , args
    end
    def == other
      compare other , [:name , :args]
    end
  end
  
  class AssignmentExpression < Expression
    attr_reader  :assignee, :assigned
    def initialize assignee, assigned
      @assignee, @assigned = assignee, assigned
    end
    def == other
      compare other , [:assignee, :assigned]
    end
  end
end