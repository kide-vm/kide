module Ruby

  class SendStatement < Statement
    attr_reader :name , :receiver , :arguments

    def initialize(name , receiver , arguments )
      @name , @receiver , @arguments = name , receiver , arguments
      @arguments ||= []
    end

    def to_vool
      statements = Statements.new([])
      arguments = []
      @arguments.each_with_index do |arg , index |
        normalize_arg(arg , arguments , statements)
      end
      if statements.empty?
        return SendStatement.new(@name, @receiver , @arguments)
      else
        statements << SendStatement.new(@name, @receiver , arguments)
        return statements
      end
    end

    def to_vool_arg(arg , arguments , statements)
      if arg.respond_to?(:slot_definition) and !arg.is_a?(SendStatement)
        arguments << arg
        return
      end
      assign = LocalAssignment.new( "tmp_#{arg.object_id}".to_sym, arg)
      statements << assign
      arguments << LocalVariable.new(assign.name)
    end

    def to_s
      "#{receiver}.#{name}(#{arguments.join(', ')})"
    end
  end
end
