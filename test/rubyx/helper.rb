require_relative "../helper"

module RubyX

  module RubyXHelper
    def setup
    end
    def ruby_to_vool(input, options = {})
      options = RubyX.default_test_options.merge(options)
      RubyXCompiler.new(options).ruby_to_vool(input)
    end
    def ruby_to_mom(input , options = {})
      options = RubyX.default_test_options.merge(options)
      RubyXCompiler.new(options).ruby_to_mom(input)
    end
    def compile_in_test( input , options = {})
      vool = ruby_to_vool(in_Test(input) , options)
      vool.to_mom(nil)
      itest = Parfait.object_space.get_class_by_name(:Test)
      assert itest
      itest
    end

  end
end
