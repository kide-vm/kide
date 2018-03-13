module Mom
  class Statement
    include Common::List
    # flattening will change the structure from a tree to a linked list (and use
    # nekst to do so)
    def flatten(options = {})
      raise "not implemented for #{self}"
    end
  end

  class Statements < Statement
    include Common::Statements

    def flatten( options = {} )
      flat = @statements.shift.flatten(options)
      while( nekst = @statements.shift )
        flat.append nekst.flatten(options)
      end
      flat
    end

    def initialize(arr)
      super(arr)
      arr.each {|s|
        raise "Not a Statement #{s}" unless s.is_a?( Statement) or s.is_a?(Instruction)
      }
    end
  end

end

require_relative "if_statement"
require_relative "while_statement"
