module Melon

  class TypeCollector < AST::Processor

    def initialize
      @ivars = {}
    end

    def collect(statement)
      process statement
      @ivars
    end

    def on_ivar(statement)
      add_ivar(statement)
    end

    def on_ivasgn( statement )
      add_ivar(statement)
    end

    def add_ivar(statement)
      var = statement.children[0].to_s[1..-1].to_sym
      @ivars[var] = :Object #guess, can maybe guess better
    end
    
    def handler_missing(node)
      node.children.each do |kid |
        process(kid) if kid.is_a?(AST::Node)
      end
    end
  end
end
