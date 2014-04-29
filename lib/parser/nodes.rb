# ast classes
module Parser
  class Expression
    def eval 
      raise "abstract"
    end
    def compare other , attributes
      attributes.each do |a|
        left = send(a)
        right = other.send( a)
        return false unless left.class == right.class 
        return false unless left == right
      end
      return true
    end
  end

  class IntegerExpression < Expression
    attr_reader :value
    def initialize val
      @value = val
    end
    def == other
      compare other , [:value]
    end
  end

  class NameExpression < Expression
    attr_reader  :name
    def initialize name
      @name = name
    end
    def == other
      compare other ,  [:name]
    end
  end

  class StringExpression < Expression
    attr_reader  :string
    def initialize str
      @string = str
    end
    def == other
      compare other ,  [:string]
    end
  end

  class FuncallExpression < Expression
    attr_reader  :name, :args
    def initialize name, args
      @name , @args = name , args
    end
    def == other
      compare other , [:name , :args]
    end
  end

  class ConditionalExpression < Expression
    attr_reader  :cond, :if_true, :if_false
    def initialize cond, if_true, if_false
      @cond, @if_true, @if_false = cond, if_true, if_false
    end
    def == other
      compare other , [:cond, :if_true, :if_false]
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
  class FunctionExpression < Expression
    attr_reader  :name, :params, :block
    def initialize name, params, block
      @name, @params, @block = name, params, block
    end
    def == other
      compare other , [:name, :params, :block]
    end
  end
end
