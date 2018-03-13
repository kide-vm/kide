module Mom
  class Statement
    include Common::List
    # flattening will change the structure from a tree to a linked list (and use
    # nekst to do so)
    def flatten(options = {})
      raise "not implemented for #{self}"
    end
  end

end

require_relative "statements"
require_relative "if_statement"
require_relative "while_statement"
