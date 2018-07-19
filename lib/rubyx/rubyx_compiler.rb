module RubyX
  class RubyXCompiler
    attr_reader :source

    def initialize(source)
      @source = source
    end

    def ruby_to_vool
      ruby = Ruby::RubyCompiler.compile( source )
      vool = ruby.to_vool
      vool
    end

    def ruby_to_mom
      vool = ruby_to_vool
      vool.to_mom(nil)
    end

    def ruby_to_risc(platform)
      mom = ruby_to_mom
      mom.translate(platform)
    end

    def ruby_to_binary(platform)
      Parfait.boot!
      Risc.boot!
      linker = ruby_to_risc(platform)
      linker.position_all
      linker.create_binary
      linker
    end
  end
end
