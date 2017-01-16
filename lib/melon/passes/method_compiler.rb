module Melon
  module Passes

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
        w.name = Vm::Tree::InstanceName.new( name[1..-1].to_sym)
        w.value = process(value)
        w
      end

      def on_ivar( var )
        name = var.children.first
        w = Vm::Tree::FieldAccess.new()
        w.receiver = Vm::Tree::KnownName.new(:self)
        w.field = Vm::Tree::InstanceName.new( name[1..-1].to_sym)
        w
      end

      def on_send( statement )
        receiver , name , args = *statement
        w = Vm::Tree::CallSite.new()
        puts "receiver #{statement}"
        w.name = name
        w.arguments = process(args) || []
        w.receiver = process(receiver)
        w
      end

      def on_lvar(statement)
        name = statement.children.first.to_sym
        if(@ruby_method.args_type.variable_index(name))
          return Vm::Tree::ArgumentName.new(name)
        end
        raise "Not found #{name}"
      end

      def on_str( string )
        Vm::Tree::StringExpression.new(string.children.first)
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
