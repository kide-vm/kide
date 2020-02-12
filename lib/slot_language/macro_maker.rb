
module SlotLanguage
  # MacroMaker instances represent Macros at the Slot level
  #
  # Macros are like SlotInstruction instances in that they transform to Risc
  # But all SlotInstructions form a whole that lets us reduce Sol to Slot to risc.
  # Each Macro on the other hand represents a functionality (kind of method)
  # that can not be coded in sol. It transforms to a sequence of risc Instructions
  # that can not be coded any other way. They are not Methods, as they have no
  # scope, hence the name Macro.
  #
  # This MacroMaker is an attempt to code these kind of sequences in SlotLanguage
  # The SlotCompiler is used to transform a file of SlotLanguage code into and
  # array of SlotLanguage constructs, which in turn can be transformed into
  # SlotInstructions.
  # To start with we work backwards from existing large SlotInstructions, to
  # get a list of constructs that will transform to the same SlotInstructions
  # that transform to the same  risc as the current large instruction (+ some redundandency)
  class MacroMaker
    # an array of Makers
    attr_reader :source

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
    def initialize( source )
      @source = source
      raise "undefined source #{source}" unless source.is_a?(Array)
    end

    # Basically calls to_slot on each Element of the source array
    #
    # Thus transforming an array of Makers into a linked list of
    # SlotInstructions.
    # Return the head of the linked list.
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
