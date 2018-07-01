require_relative "../helper"

module RubyX
  module RubyXHelper
    def setup
      Parfait.boot!
      Risc.machine.boot
    end
    def ruby_to_risc(input , platform)
      mom = ruby_to_mom(input)
      puts "MOM #{mom.class}"
      mom.translate(platform)
    end
    def ruby_to_vool(input)
      RubyXCompiler.new(input).ruby_to_vool
    end
    def ruby_to_mom(input)
      RubyXCompiler.new(input).ruby_to_mom
    end
    def compile_in_test input
      vool = ruby_to_vool in_Test(input)
      vool.to_mom(nil)
      itest = Parfait.object_space.get_class_by_name(:Test)
      assert itest
      itest
    end

  end
end
