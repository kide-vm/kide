module Vool
  class Statements < Statement
    include Common::Statements

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
      @statements.each{|a| a.each(block)}
    end

  end

  class ScopeStatement < Statements
  end
end
