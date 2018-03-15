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
    def add_array(a)
      @statements += a
    end

    # create machine instructions
    def to_mom( method )
      raise "Empty list ? #{statements.length}" unless @statements[0]
      flat = @statements.shift.to_mom(method)
      while( nekst = @statements.shift )
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
      Statements.new(@statements.collect{|s| s.normalize})
    end
  end

  class ScopeStatement < Statements
    def normalize
      ScopeStatement.new(@statements.collect{|s| s.normalize})
    end
  end
end
