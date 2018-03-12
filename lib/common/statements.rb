module Common
  #extracted to resuse
  module Statements
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
    end
    def collect(arr)
      @statements.each { |s| s.collect(arr) }
      super
    end
    def add_array(a)
      @statements += a
    end
  end
end
