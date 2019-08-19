module Ruby

  class Assignment < Statement
    attr_reader :name , :value
    def initialize(name , value )
      @name , @value = name , value
    end

    def to_vool()
      raise "not named left #{name.class}" unless name.is_a?(Symbol)
      case value
      when Variable , Constant
        return self.vool_brother.new(name,@value.to_vool)
      when SendStatement , YieldStatement , RubyBlockStatement
        return normalize_send
      else
        raise "unsupported right #{value}"
      end
    end

    # sends may have complex args that get hoisted in vool:ing them
    # in which case we have to assign the simplified, otherwise the
    # plain send
    def normalize_send
      statements = value.to_vool
      return assignment( statements ) if statements.is_a?(Vool::CallStatement)
      # send has hoisted assigns, so we make an assign out of the "pure" send
      statements << assignment(statements.statements.pop)
      statements
    end

    # create same type assignment with the value (a send)
    def assignment(value)
      value ||= @value
      self.vool_brother.new(name,value)
    end

    def to_s(depth = 0)
      at_depth(depth , "#{@name} = #{@value}")
    end

  end

  class IvarAssignment < Assignment

  end

  class LocalAssignment < Assignment

  end

end
