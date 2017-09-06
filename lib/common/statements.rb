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
    def length
      @statements.length
    end

    def collect(arr)
      @statements.each { |s| s.collect(arr) }
      super
    end
  end
end
