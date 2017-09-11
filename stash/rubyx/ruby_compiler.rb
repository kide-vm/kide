require "parser/ruby22"

require_relative "passes/total_processor"
require_relative "passes/type_collector"
require_relative "passes/method_collector"
require_relative "passes/method_compiler"
require_relative "passes/locals_collector"
require_relative "passes/normalizer"
require "vool/vool_method"


module Rubyx
  class RubyxCompiler < Passes::TotalProcessor

    def self.compile( input )
      ast = Parser::Ruby22.parse( input )
      self.new.process( ast )
    end

    def on_class statement
      name , sup , body = *statement
      class_name = get_name(name)
      clazz = Parfait.object_space.get_class_by_name(class_name )
      if(clazz)
        #FIXME super class check with "sup"
      else #existing class, don't overwrite type (parfait only?)
        clazz = Parfait.object_space.create_class(class_name , get_name(sup) )
        ivar_hash = Passes::TypeCollector.new.collect(body)
        clazz.set_instance_type( Parfait::Type.for_hash( clazz ,  ivar_hash ) )
      end
      methods = create_methods(clazz , body)
      compile_methods(clazz,methods)
    end

    def create_methods(clazz , body)
      methods = Passes::MethodCollector.new.collect(body)
      methods.each do |method|
        clazz.add_method( method )
        normalizer = Passes::Normalizer.new(method)
        method.normalize_source { |sourc| normalizer.process( sourc ) }
      end
      methods
    end

    def compile_methods(clazz , methods)
      methods.each do |method|
        code = Passes::MethodCompiler.new(method).get_code
        typed_method = method.create_parfait_method(clazz.instance_type)
        Vm::MethodCompiler.new( typed_method ).init_method.process( code )
      end
    end

    private

    def get_name( statement )
      return nil unless statement
      raise "Not const #{statement}" unless statement.type == :const
      name = statement.children[1]
      raise "Not symbol #{name}" unless name.is_a? Symbol
      name
    end

  end
end
