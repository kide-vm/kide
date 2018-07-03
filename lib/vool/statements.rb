module Vool
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
    def [](i)
      @statements[i]
    end
    def <<(o)
      @statements << o
      self
    end

    # create mom instructions
    def to_mom( method )
      raise "Empty list ? #{statements.length}" if empty?
      stats = @statements.dup
      flat = stats.shift.to_mom(method)
      while( nekst = stats.shift )
        flat.append nekst.to_mom(method)
      end
      flat
    end

    def create_objects
      @statements.each{ |s| s.create_objects }
    end

    def each(&block)
      block.call(self)
      @statements.each{|a| a.each(&block)}
    end

    def normalize
      if( single? )
        first.normalize
      else
        Statements.new(@statements.collect{|s| s.normalize})
      end
    end
    def to_s(depth = 0)
      at_depth(depth , *@statements.collect{|st| st.to_s(depth)})
    end

  end

  class ScopeStatement < Statements
    def normalize
      if( single? )
        first.normalize
      else
        ScopeStatement.new(@statements.collect{|s| s.normalize})
      end
    end
  end
end
