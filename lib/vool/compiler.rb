module Vool
  class Compiler < ::Rubyx::Passes::TotalProcessor

    def self.compile(input)
      ast = Parser::Ruby22.parse( input )
      self.new.process(ast)
    end

    def on_class( statement )
      name , sup , body = *statement
      ClassStatement.new( get_name(name) , get_name(sup) , body )
    end

    def on_def( statement )
      name , args , body = *statement
      arg_array = process_all( args )
      MethodStatement.new( name , arg_array , body )
    end

    def on_arg( arg )
      arg.first
    end

    def get_name( statement )
      return nil unless statement
      raise "Not const #{statement}" unless statement.type == :const
      name = statement.children[1]
      raise "Not symbol #{name}" unless name.is_a? Symbol
      name
    end

  end
end
