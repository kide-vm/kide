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
  module ParfaitHelper

    def load_parfait(file)
      File.read File.expand_path("../../../lib/parfait/#{file}.rb",__FILE__)
    end
    def load_parfait_test(file)
      File.read File.expand_path("../../parfait/test_#{file}.rb",__FILE__)
    end
    def compiler
      RubyXCompiler.new(RubyX.default_test_options)
    end

    def run_input
      linker = compiler.ruby_to_binary(@input , :interpreter)
      @interpreter = Risc::Interpreter.new(linker)
      @interpreter.start_program
      run_all
    end

    def run_all
      while(@interpreter.instruction)
        @interpreter.tick
        #puts @interpreter.instruction
      end
      @interpreter.clock
    end

  end

end
