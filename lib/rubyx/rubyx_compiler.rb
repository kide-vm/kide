require_relative "ruby_compiler"

module RubyX
  class RubyXCompiler

    def self.ruby_to_vool( ruby_source )
      vool = RubyCompiler.compile( ruby_source )
      vool = vool.normalize
      vool
    end

    def self.ruby_to_mom( ruby_source )
      vool = self.ruby_to_vool(ruby_source)
      vool.to_mom(nil)
    end

    def self.ruby_to_binary(source , platform = :arm)
      Parfait.boot!
      machine = Risc.machine.boot
      mom = ruby_to_mom(source)
      #mom.translate(platform)
      machine.translate(platform)
      machine.position_all
      machine.create_binary
    end
  end
end
