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
    def length
      @statements.length
    end

    def collect(arr)
      @statements.each { |s| s.collect(arr) }
      super
    end

    def create_objects
      @statements.each{ |s| s.create_objects }
    end
  end

  class ScopeStatement < Statements
  end
end
