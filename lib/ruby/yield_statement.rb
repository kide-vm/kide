module Ruby

  class YieldStatement < Statement
    attr_reader :arguments

    def initialize(arguments   )
      @arguments = arguments
      @arguments ||= []
    end

    def to_vool
      statements = Statements.new([])
      arguments = []
      @arguments.each_with_index do |arg , index |
        normalize_arg(arg , arguments , statements)
      end
      if statements.empty?
        return YieldStatement.new(@name, @receiver , @arguments)
      else
        statements << YieldStatement.new(@name, @receiver , arguments)
        return statements
      end
    end

    def to_vool_arg(arg , arguments , statements)
      if arg.respond_to?(:slot_definition) and !arg.is_a?(YieldStatement)
        arguments << arg
        return
      end
      assign = LocalAssignment.new( "tmp_#{arg.object_id}".to_sym, arg.to_vool)
      statements << assign
      arguments << LocalVariable.new(assign.name)
    end

    def to_s
      "#{receiver}.#{name}(#{arguments.join(', ')})"
    end
  end
end
