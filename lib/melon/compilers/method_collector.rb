module Melon
  module Compilers

    class MethodCollector < TotalProcessor

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
        locals_type = make_locals(body)
        @methods << RubyMethod.new(name , args_type , locals_type , body )
      end

      private

      def make_type( statement )
        type_hash = {}
        statement.children.each do |arg|
          type_hash[arg.children[0]] = :Object
        end
        Parfait::NamedList.type_for( type_hash )
      end

      def make_locals(body)
        type_hash = LocalsCollector.new.collect(body)
        Parfait::NamedList.type_for( type_hash )
      end
    end
  end
end
