module SlotMachine

  class MacroMaker
    # a list of instructions

    attr_reader :instructions

    # load slot code from a file, in a subdir code/ + filename
    # use load_string to compile the content
    def self.load_file(relative_name)
      path = File.expand_path(  "../code/#{relative_name}" , __FILE__)
      load_string( File.read(path))
    end

    # compile the given SlotLanguage source
    # the compiler returns an array of Makers which a new MacroMaker
    # instance stores
    # return the MacroMaker that represents the source
    def self.load_string(source_code)
      MacroMaker.new( SlotCompiler.compile(source_code) )
    end

    # must initialize with an array of Makers, which is stored
    def initialize( instructions )
      @instructions = instructions
      raise "undefined source #{instructions}" unless instructions.is_a?(Instruction)
    end

  end
end
