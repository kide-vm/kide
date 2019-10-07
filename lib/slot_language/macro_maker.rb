
module SlotLanguage
  class MacroMaker
    attr_reader :source

    def self.load_file(relative_name)
      path = File.expand_path(  "../code/#{relative_name}" , __FILE__)
      load_string( File.read(path))
    end
    def self.load_string(source_code)
      MacroMaker.new( SlotCompiler.compile(source_code) )
    end

    def initialize( source )
      @source = source
      raise "undefined source #{source}" unless source.is_a?(Array)
    end

    def to_slot(compiler)
      chain = do_link( @source.first , compiler)
      rest = @source.dup
      rest.shift
      rest.each do |link|
        chain << do_link(link , compiler)
      end
      chain
    end

    private
    def do_link(link,compiler)
      return link if link.is_a?(SlotMachine::Instruction)
      link.to_slot(compiler)
    end
  end
end
