require_relative "ruby_compiler"

module RubyX
  class RubyXCompiler

    def self.ruby_to_vool( ruby_source )
      vool = RubyCompiler.compile( ruby_source )
      vool = vool.normalize
      vool
    end

    def self.ruby_to_binary(source , platform = :arm)
      machine = Risc.machine.boot
      vool = self.ruby_to_vool(source)
      vool.to_mom(nil).class
      machine.translate(platform)
      machine.position_all
      machine.create_binary
    end
  end
end
