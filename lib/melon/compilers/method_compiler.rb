module Melon
  module Compilers

    class MethodCompiler < AST::Processor

      def initialize( ruby_method )
        @ruby_method = ruby_method
      end

      def get_code
        process(@ruby_method.source)
      end

      def on_ivasgn(statement)
        name , value = *statement
        w = Vm::Tree::Assignment.new()
        w.name = Vm::Tree::NameExpression.new( name[1..-1].to_sym)
        w.value = process(value)
        w
      end

      def on_ivar( var )
        name = var.children.first
        w = Vm::Tree::FieldAccess.new()
        w.receiver = Vm::Tree::NameExpression.new(:self)
        w.field = Vm::Tree::NameExpression.new( name[1..-1].to_sym)
        w
      end

      def on_int( expression)
        Vm::Tree::IntegerExpression.new(expression.children.first)
      end

      def handler_missing(node)
        raise "No handler for #{node}"
      end

    end
  end
end
