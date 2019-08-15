module Ruby
  class Statements < Statement
    attr_reader :statements
    def initialize(statements)
      @statements = statements
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
    def shift
      @statements.shift
    end
    def [](i)
      @statements[i]
    end
    def <<(o)
      @statements << o
      self
    end
    def to_vool
      if( single? )
       first.to_vool
      else
       vool_brother.new(@statements.collect{|s| s.to_vool})
      end
    end

    def to_s(depth = 0)
      at_depth(depth , *@statements.collect{|st| st.to_s(depth)})
    end

  end

  class ScopeStatement < Statements
  end
end
