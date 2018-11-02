module RubyX
  # The RubyXCompiler provides the main interface to create binaries
  #
  # There are methods to go from ruby to any of the layers in the system
  # (mainly for testing). ruby_to_binary creates actual binary code
  # for a given platform.
  # Only builtin is loaded, so no runtime , but the compiler
  # can be used to read the runtime and then any other code
  #
  class RubyXCompiler

    # initialize boots Parfait and Risc (ie load Builin)
    def initialize
      Parfait.boot!
      Risc.boot!
    end

    # The highest level function creates binary code for the given ruby code
    # for the given platform (see Platform). Binary code means that vool/mom/risc
    # are created and then assembled into BinaryCode objects.
    # (no executable is generated, only the binary code and objects needed for a binary)
    #
    # A Linker is returned that may be used to create an elf binay
    #
    # The compiling is done by ruby_to_risc
    def ruby_to_binary(ruby , platform)
      linker = ruby_to_risc(ruby, platform)
      linker.position_all
      linker.create_binary
      linker
    end

    # ruby_to_risc creates Risc instructions (as the name implies), but also
    # translates those to the platform given
    #
    # The higher level translation is done by ruby_to_mom
    def ruby_to_risc(ruby, platform)
      mom = ruby_to_mom(ruby)
      mom.translate(platform)
    end

    # ruby_to_mom does exactly that, it transform the incoming ruby source (string)
    # to mom
    #
    # the method calls ruby_to_vool to compile the first layer
    def ruby_to_mom(ruby)
      vool_tree = ruby_to_vool(ruby)
      vool_tree.to_mom(nil)
    end

    # ruby_to_vool compiles the ruby to ast, and then to vool
    def ruby_to_vool(ruby_source)
      ruby_tree = Ruby::RubyCompiler.compile( ruby_source )
      vool_tree = ruby_tree.to_vool
      vool_tree
    end


    def self.ruby_to_binary( ruby , platform)
      compiler = RubyXCompiler.new
      vool_tree = compiler.ruby_to_vool(ruby)

      # integrate other sources into vool tree

      mom = vool_tree.to_mom(nil)
      linker = mom.translate(platform)
      linker.position_all
      linker.create_binary
      linker
    end
  end
end
