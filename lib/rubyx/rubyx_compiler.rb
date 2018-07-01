require_relative "ruby_compiler"

module RubyX
  class RubyXCompiler
    attr_reader :source

    def initialize(source)
      @source = source
    end

    def ruby_to_vool
      vool = RubyCompiler.compile( source )
      vool = vool.normalize
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

    def ruby_to_binary(platform = :arm)
      Parfait.boot!
      Risc.boot!
      linker = ruby_to_risc(platform)
      linker.position_all
      linker.create_binary
    end
  end
end
