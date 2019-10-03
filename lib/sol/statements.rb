module Sol
  class Statements < Statement
    attr_reader :statements
    def initialize(statements)
      case statements
      when nil
        @statements = []
      when Array
        @statements = statements
      when Statement
        @statements = statements.statements
      when Statement
        @statements = [statements]
      else
        raise "Invalid class, must be Statement or Array, not #{statements.class}"
      end
    end

    def empty?
      @statements.empty?
    end
    def single?
      @statements.length == 1
    end
    def first
      @statements.first
    end
    def last
      @statements.last
    end
    def length
      @statements.length
    end
    def [](i)
      @statements[i]
    end
    def <<(o)
      if(o.is_a?(Statements))
        o.statements.each do |s|
          raise "not a statement #{s}" unless s.is_a?(Statement)
          @statements << s
        end
      else
        raise "not a statement #{o}" unless o.is_a?(Statement)
        @statements << o
      end
      self
    end
    def prepend(o)
      raise "not a statement #{o}" unless o.is_a?(Statement)
      @statements = [o] + @statements
    end
    def shift
      @statements.shift
    end
    def pop
      @statements.pop
    end

    # apply for all statements , return collection (for testing)
    def to_parfait
      @statements.collect{|s| s.to_parfait}
    end
    # to_slot all the statements. Append subsequent ones to the first, and return the
    # first.
    #
    # For ClassStatements this creates and returns a SlotMachineCompiler
    #
    def to_slot( compiler )
      raise "Empty list ? #{statements.length}" if empty?
      stats = @statements.dup
      first = stats.shift.to_slot(compiler)
      while( nekst = stats.shift )
        next_slot = nekst.to_slot(compiler)
        first.append next_slot
      end
      first
    end

    def each(&block)
      block.call(self)
      @statements.each{|a| a.each(&block)}
    end

    def to_s(depth = 0)
      at_depth(depth , @statements.collect{|st| st.to_s(depth)}.join("\n"))
    end

  end

  class ScopeStatement < Statements
  end
end
