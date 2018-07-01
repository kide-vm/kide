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

    def ruby_to_binary(platform = :arm)
      Parfait.boot!
      machine = Risc.machine.boot
      mom = ruby_to_mom
      puts "MOM #{mom.class}"
      mom.translate(platform)
      #machine.translate(platform)
      machine.position_all
      machine.create_binary
    end
  end
end
