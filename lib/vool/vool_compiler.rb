require_relative "ruby_compiler"

module Vool
  class VoolCompiler

    def self.ruby_to_vool( ruby_source )
      statements = RubyCompiler.compile( ruby_source )
      statements = statements.normalize
      statements.create_objects
      statements
    end
    def self.ruby_to_mom(source)
      statements = self.ruby_to_vool(source)
      statements.to_mom(nil)
    end
    def self.ruby_to_binary(source)
      machine = Risc.machine.boot
      self.ruby_to_vool(source)
      machine.position_all
      machine.create_binary
    end
  end
end
