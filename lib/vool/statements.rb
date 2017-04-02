module Vool
  class Statements < Statement
    attr_accessor :statements
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
  end

  class ScopeStatement < Statements
  end
end
