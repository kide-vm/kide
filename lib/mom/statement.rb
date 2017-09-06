module Mom
  class Statement
    # flattening will change the structure from a tree to a linked list (and use
    # next_instruction to do so)
    def flatten
      raise "not implemented for #{self}"
    end
  end

  class Statements < Statement
    include Common::Statements

    def flatten
      @statements.each{ |s| s.flatten }
    end
  end

end

require_relative "if_statement"
require_relative "while_statement"
