require_relative "compiler/total_processor"
require_relative "compiler/type_collector"
require_relative "compiler/method_collector"
require_relative "compiler/locals_collector"
require_relative "compiler/ruby_method"


module Melon
  class Compiler < TotalProcessor

    def self.compile( input )
      ast = Parser::Ruby22.parse( input )
      self.new.process( ast )
    end

    def on_class statement
      name , sup , body = *statement
      class_name = get_name(name)
      clazz = Parfait.object_space.get_class_by_name!(class_name , get_name(sup) )
      ivar_hash = TypeCollector.new.collect(body)
      clazz.set_instance_type( Parfait::Type.for_hash( clazz ,  ivar_hash ) )
      create_methods(clazz , body)
    end

    def create_methods(clazz , body)
      methods = MethodCollector.new.collect(body)
      methods.each do |method|
        clazz.add_method( method )
      end
    end

    private

    def get_name( statement )
      return nil unless statement
      statement.children[1]
    end

  end
end
