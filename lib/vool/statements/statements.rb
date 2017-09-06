module Vool
  class Statements < Statement
    include Common::Statements

    # create machine instructions
    def to_mom( method )
      all = @statements.collect { |statement| statement.to_mom( method ) }
      Mom::Statements.new(all)
    end

    def create_objects
      @statements.each{ |s| s.create_objects }
    end
  end

  class ScopeStatement < Statements
  end
end
