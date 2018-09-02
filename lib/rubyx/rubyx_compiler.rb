module RubyX
  class RubyXCompiler

    def initialize
      Parfait.boot!
      Risc.boot!
    end

    def ruby_to_vool(ruby_source)
      ruby_tree = Ruby::RubyCompiler.compile( ruby_source )
      vool_tree = ruby_tree.to_vool
      vool_tree
    end

    def ruby_to_mom(ruby)
      vool_tree = ruby_to_vool(ruby)
      vool_tree.to_mom(nil)
    end

    def ruby_to_risc(ruby, platform)
      mom = ruby_to_mom(ruby)
      mom.translate(platform)
    end

    def ruby_to_binary(ruby , platform)
      linker = ruby_to_risc(ruby, platform)
      linker.position_all
      linker.create_binary
      linker
    end
  end
end
