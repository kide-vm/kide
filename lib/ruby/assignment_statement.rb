module Ruby

  class Assignment < Statement
    attr_reader :name , :value
    def initialize(name , value )
      @name , @value = name , value
    end

    def to_vool()
      raise "not named left #{name.class}" unless name.is_a?(Symbol)
      case value
      when Named , Constant
        return copy
      when SendStatement
        return normalize_send
      else
        raise "unsupported right #{value}"
      end
    end

    def copy(value = nil)
      value ||= @value
      self.class.new(name,value)
    end

    def to_vool_send
      statements = value.normalize()
      return copy( statements ) if statements.is_a?(SendStatement)
      assign = statements.statements.pop
      statements << copy(assign)
      statements
    end

    def to_s(depth = 0)
      at_depth(depth , "#{@name} = #{@value}")
    end

  end

  class IvarAssignment < Assignment

    def to_vool()
      super()
      return IvarAssignment.new(@name , @value)
    end
  end

  class LocalAssignment < Assignment

  end

end
