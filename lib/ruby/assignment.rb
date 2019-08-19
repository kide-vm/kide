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
      when SendStatement , YieldStatement
        return normalize_send
      when RubyBlockStatement
        return normalize_block
      else
        raise "unsupported right #{value}"
      end
    end

    # Ruby BlockStatements have the block and the send. Normalize the send
    # and assign it (it is the last in the list)
    def normalize_block
      statements = value.to_vool
      index = statements.length - 1
      snd = statements.statements[index]
      raise "Expecting Send #{snd.class}:#{snd}" unless snd.is_a?( Vool::SendStatement)
      statements.statements[index] = assignment( snd )
      statements
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
