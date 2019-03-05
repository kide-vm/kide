module Ruby
  class ClassStatement < Statement
    attr_reader :name, :super_class_name , :body

    def initialize( name , supe , body)
      @name , @super_class_name = name , supe
      case body
      when MethodStatement , SendStatement
        @body = Statements.new([body])
      when Statements
        @body = body
      when nil
        @body = Statements.new([])
      else
        raise "what body #{body.class}:#{body}"
      end
    end

    def to_vool
      meths = body.statements.collect do |meth|
        meth.is_a?(MethodStatement) ?  meth.to_vool : tranform_statement(meth)
      end
      Vool::ClassStatement.new(@name , @super_class_name, Vool::Statements.new(meths) )
    end

    def tranform_statement( class_send )
      unless class_send.is_a?(SendStatement)
        raise "Other than methods, only class methods allowed, not #{class_send.class}"
      end
      unless class_send.name == :attr
        raise "Only remapping attr and cattr, not #{class_send.name}"
      end
      raise "todo"
    end

    def to_s(depth = 0)
      at_depth(depth , "class #{name}" , @body.to_s(depth + 1) , "end")
    end
  end
end
