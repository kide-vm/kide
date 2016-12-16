require_relative "attributed"

module Arm

  # A Machines main responsibility in the framework is to instantiate Instructions

  # Value functions are mapped to machines by concatenating the values class name + the methd name
  # Example:  IntegerValue.plus( value ) ->  Machine.signed_plus (value )

  # Also, shortcuts are created to easily instantiate Instruction objects.
  # Example:  pop -> StackInstruction.new( {:opcode => :pop}.merge(options) )
  # Instructions work with options, so you can pass anything in, and the only thing the functions
  # does is save you typing the clazz.new. It passes the function name as the :opcode

  class ArmMachine

    # conditions specify all the possibilities for branches. Branches are b +  condition
    # Example:  beq means brach if equal.
    # :al means always, so bal is an unconditional branch (but b() also works)
    CONDITIONS = [:al ,:eq ,:ne ,:lt ,:le ,:ge,:gt ,:cs ,:mi ,:hi ,:cc ,:pl,:ls ,:vc ,:vs]

    # here we create the shortcuts for the "standard" instructions, see above
    # Derived machines may use own instructions and define functions for them if so desired
    def self.init
      [:push, :pop].each do |inst|
        define_instruction_one(inst , StackInstruction)
      end
      [:adc, :add, :and, :bic, :eor, :orr, :rsb, :rsc, :sbc, :sub , :mul].each do |inst|
        define_instruction_three(inst , LogicInstruction)
      end
      [:mov, :mvn].each do |inst|
        define_instruction_two(inst , MoveInstruction)
      end
      [:cmn, :cmp, :teq, :tst].each do |inst|
        define_instruction_two(inst , CompareInstruction)
      end
      [:strb, :str , :ldrb, :ldr].each do |inst|
        define_instruction_three(inst , MemoryInstruction)
      end
      [:b, :call , :swi].each do |inst|
        define_instruction_one(inst , CallInstruction)
      end
      # create all possible brach instructions, but the CallInstruction demangles the
      # code, and has opcode set to :b and :condition_code set to the condition
      CONDITIONS.each do |suffix|
        define_instruction_one("b#{suffix}".to_sym , CallInstruction)
        define_instruction_one("call#{suffix}".to_sym , CallInstruction)
      end
    end

    def self.def_method(name,  &block)
        self.class.send(:define_method, name , &block)
    end

    def self.class_for clazz
      my_module = self.class.name.split("::").first
      clazz_name = clazz.name.split("::").last
      if(my_module != Register )
        module_class = eval("#{my_module}::#{clazz_name}") rescue nil
        clazz = module_class if module_class
      end
      clazz
    end

    #defining the instruction (opcode, symbol) as an given class.
    # the class is a Register::Instruction derived base class and to create machine specific function
    #  an actual machine must create derived classes (from this base class)
    # These instruction classes must follow a naming pattern and take a hash in the contructor
    #  Example, a mov() opcode  instantiates a Register::MoveInstruction
    #   for an Arm machine, a class Arm::MoveInstruction < Register::MoveInstruction exists, and it
    #   will be used to define the mov on an arm machine.
    # This methods picks up that derived class and calls a define_instruction methods that can
    #   be overriden in subclasses
    def self.define_instruction_one(inst , clazz ,  defaults = {} )
      clazz = class_for(clazz)
      def_method(inst) do |first , options = nil|
        options = {} if options == nil
        options.merge defaults
        options[:opcode] = inst
        first = Register::RegisterValue.convert(first)
        clazz.new(first , options)
      end
    end

    # same for two args (left right, from to etc)
    def self.define_instruction_two(inst , clazz ,  defaults = {} )
      clazz =  self.class_for(clazz)
      def_method(inst) do |left ,right , options = nil|
        options = {} if options == nil
        options.merge defaults
        left = Register::RegisterValue.convert(left)
        right = Register::RegisterValue.convert(right)
        options[:opcode] = inst
        clazz.new(left , right ,options)
      end
    end

    # same for three args (result = left right,)
    def self.define_instruction_three(inst , clazz ,  defaults = {} )
      clazz =  self.class_for(clazz)
      def_method(inst) do |result , left ,right = nil , options = nil|
        options = {} if options == nil
        options.merge defaults
        options[:opcode] = inst
        result = Register::RegisterValue.convert(result)
        left = Register::RegisterValue.convert(left)
        right = Register::RegisterValue.convert(right)
        clazz.new(result, left , right ,options)
      end
    end
  end
end
Arm::ArmMachine.init
