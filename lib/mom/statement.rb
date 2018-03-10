module Mom
  class Statement
    # flattening will change the structure from a tree to a linked list (and use
    # nekst to do so)
    def flatten
      raise "not implemented for #{self}"
    end
  end

  class Statements < Statement
    include Common::Statements

    def flatten( options = {}  )
      flat = @statements.pop.flatten
      while( nekst = @statements.pop )
        flat.append nekst.flatten()
      end
      flat
    end

    def <<(o)
      @statements << o
    end

  end

end

require_relative "if_statement"
require_relative "while_statement"
