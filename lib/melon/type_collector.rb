module Melon

  class TypeCollector < AST::Processor

    def initialize
      @ivar_names = []
    end

    def collect(statement)
      process statement
      @ivar_names
    end

    def on_ivar(statement)
      @ivar_names.push statement.children[0].to_s[1..-1].to_sym
    end

    def handler_missing(node)
      node.children.each do |kid |
        process(kid) if kid.is_a?(AST::Node)
      end
    end
  end
end
