module Ruby

  class SendStatement < Statement
    attr_reader :name , :receiver , :arguments

    def initialize(name , receiver , arguments )
      @name , @receiver , @arguments = name , receiver , arguments
      @arguments ||= []
    end

    def to_vool
      statements = Vool::Statements.new([])
      arguments = []
      @arguments.each_with_index do |arg , index |
        normalize_arg(arg , arguments , statements)
      end
      if statements.empty?
        return Vool::SendStatement.new(@name, @receiver.to_vool , arguments)
      else
        statements << Vool::SendStatement.new(@name, @receiver.to_vool , arguments)
        return statements
      end
    end

    def normalize_arg(arg , arguments , statements)
      if arg.respond_to?(:ct_type) and !arg.is_a?(SendStatement)
        arguments << arg.to_vool
        return
      end
      assign = Vool::LocalAssignment.new( "tmp_#{arg.object_id}".to_sym, arg)
      statements << assign
      arguments << Vool::LocalVariable.new(assign.name)
    end

    def to_s
      "#{receiver}.#{name}(#{arguments.join(', ')})"
    end
  end
end
