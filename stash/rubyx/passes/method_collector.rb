module Rubyx
  module Passes

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
        frame_type = make_locals(body)
        @methods << Vool::VoolMethod.new(name , args_type , frame_type , body )
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