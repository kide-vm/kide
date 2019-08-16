require_relative "../helper"

module RubyX
  module ParfaitHelper

    def load_parfait(file)
      File.read File.expand_path("../../../../lib/parfait/#{file}.rb",__FILE__)
    end
    def compiler
      RubyXCompiler.new(RubyX.default_test_options)
    end
  end
end
