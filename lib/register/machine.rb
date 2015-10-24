require 'parslet/convenience'
require_relative "collector"
module Register
  # The Register Machine is a object based virtual machine on which ruby will be implemented.
  #

  # The ast is transformed to virtual-machine objects, some of which represent code, some data.
  #
  # The next step transforms to the register machine layer, which is quite close to what actually
  #  executes. The step after transforms to Arm, which creates executables.
  #

  class Machine
    include Collector

    def initialize
      @parser  = Parser::Salama.new
      @objects = {}
      @booted = false
    end
    attr_reader :space , :class_mappings , :init , :objects , :booted


    # idea being that later method missing could catch translate_xxx and translate to target xxx
    # now we just instantiate ArmTranslater and pass instructions
    def translate_arm
      translator = Arm::Translator.new
      methods = []
      @space.classes.values.each do |c|
        c.instance_methods.each do |f|
          methods << f.source
        end
      end
      methods.each do |method|
        instruction = method.instructions
        begin
          nekst = instruction.next
          t = translate(translator , nekst) # returning nil means no replace
          instruction.replace_next(t) if t
          instruction = nekst
        end while instruction.next
      end
    end

    # translator should translate from register instructio set to it's own (arm eg)
    # for each instruction we call the translator with translate_XXX
    #  with XXX being the class name.
    # the result is replaced in the stream
    def translate translator , instruction
      class_name = instruction.class.name.split("::").last
      translator.send( "translate_#{class_name}".to_sym , instruction)
    end


    # Objects are data and get assembled after functions
    def add_object o
      return false if @objects[o.object_id]
      return if o.is_a? Fixnum
      raise "adding non parfait #{o.class}" unless o.is_a? Parfait::Object or o.is_a? Symbol
      @objects[o.object_id] = o
      true
    end

    def boot
      boot_parfait!
      @init =  Branch.new( "__init__" , self.space.get_init.source.instructions )
      @booted = true
      self
    end

    def parse_and_compile bytes
      syntax  = @parser.parse_with_debug(bytes)
      parts = Parser::Transform.new.apply(syntax)
      #puts parts.inspect
      Soml::Compiler.compile( parts )
    end

    private
    def run_blocks_for pass_class
      parts = pass_class.split("::")
      pass = Object.const_get(parts[0]).const_get parts[1]
      raise "no such pass-class as #{pass_class}" unless pass
      @blocks.each do |block|
        raise "nil block " unless block
        pass.new.run(block)
      end
    end

  end

  # Module function to retrieve singleton
  def self.machine
    unless defined?(@machine)
      @machine = Machine.new
    end
    @machine
  end

end

Parfait::Method.class_eval do
  # for testing we need to reuse the main function (or do we?)
  # so remove the code that is there
  def clear_source
    self.source.send :initialize , self
  end

end

require_relative "boot"
