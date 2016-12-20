module Melon

  class MethodCollector < AST::Processor

    def initialize
      @methods = []
    end

    def collect(statement)
      process statement
      @methods
    end

    def on_def(statement)
      name , args , body = *statement
      args_type = make_type(args)
      @methods << RubyMethod.new(name , args_type , body )
    end

    def make_type( statement )
      type = Parfait::Space.object_space.get_class_by_name(:Message ).instance_type
      statement.children.each do |arg|
        type = type.add_instance_variable( arg.children[0] , :Object )
      end
      type
    end

    def handler_missing(node)
      node.children.each do |kid |
        process(kid) if kid.is_a?(AST::Node)
      end
    end

  end
end
