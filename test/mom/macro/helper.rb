require_relative "../helper"

module Mom
  module Builtin
    class BootTest < MiniTest::Test
      include Preloader

      def get_compiler(clazz , name)
        compiler = RubyX::RubyXCompiler.new(RubyX.default_test_options)
        coll = compiler.ruby_to_mom( get_preload("Space.main;#{clazz}.#{name}") )
        @method = coll.method_compilers.last
        @method
      end

    end
  end
end
