require "parser/ruby22"

require_relative "compilers/total_processor"
require_relative "compilers/type_collector"
require_relative "compilers/method_collector"
require_relative "compilers/locals_collector"
require_relative "compilers/normalizer"
require_relative "ruby_method"


module Melon
  class RubyCompiler < Compilers::TotalProcessor

    def self.compile( input )
      ast = Parser::Ruby22.parse( input )
      self.new.process( ast )
    end

    def on_class statement
      name , sup , body = *statement
      class_name = get_name(name)
      clazz = Parfait.object_space.get_class_by_name!(class_name , get_name(sup) )
      ivar_hash = Compilers::TypeCollector.new.collect(body)
      clazz.set_instance_type( Parfait::Type.for_hash( clazz ,  ivar_hash ) )
      methods = create_methods(clazz , body)
      compiler_methods(methods)
    end

    def create_methods(clazz , body)
      methods = Compilers::MethodCollector.new.collect(body)
      methods.each do |method|
        clazz.add_method( method )
        normalizer = Compilers::Normalizer.new(method)
        method.normalize_source { |sourc| normalizer.process( sourc ) }
      end
      methods
    end

    def compiler_methods(methods)
      methods.each do |method|
      end
    end

    private

    def get_name( statement )
      return nil unless statement
      statement.children[1]
    end

  end
end
