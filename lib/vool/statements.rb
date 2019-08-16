module Vool
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
        o.each {|s| @statements << s }
      else
        @statements << o
      end
      self
    end
    def prepend(o)
      @statements = [o] + @statements
    end
    def shift
      @statements.shift
    end
    def pop
      @statements.pop
    end

    # to_mom all the statements. Append subsequent ones to the first, and return the
    # first.
    #
    # For ClassStatements this creates and returns a MomCompiler
    #
    def to_mom( compiler )
      raise "Empty list ? #{statements.length}" if empty?
      stats = @statements.dup
      first = stats.shift.to_mom(compiler)
      while( nekst = stats.shift )
        first.append nekst.to_mom(compiler)
      end
      first
    end

    def each(&block)
      block.call(self)
      @statements.each{|a| a.each(&block)}
    end

    def to_s(depth = 0)
      at_depth(depth , *@statements.collect{|st| st.to_s(depth)})
    end

  end

  class ScopeStatement < Statements
  end
end
