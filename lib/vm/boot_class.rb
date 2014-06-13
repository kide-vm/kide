require_relative "meta_class"

module Vm
  # class is mainly a list of functions with a name (for now)
  # layout of object is seperated into Layout
  class BootClass < ObjectConstant
    def initialize name , context , super_class = :Object
      super()
      @context = context
      # class functions
      @functions = []
      @name = name.to_sym
      @super_class = super_class
      @meta_class = MetaClass.new(self)
    end
    attr_reader :name , :functions , :meta_class , :context
    
    def add_function function
      raise "not a function #{function}" unless function.is_a? Function
      raise "syserr " unless function.name.is_a? Symbol
      @functions << function
    end

    def get_function fname
      fname = fname.to_sym
      f = @functions.detect{ |f| f.name == fname }
      names = @functions.collect{|f| f.name } 
      f
    end

    # get the function and if not found, try superclasses. raise error if not found
    def resolve_function name
      fun = get_function name
      unless fun or name == :Object
        supr = @context.object_space.get_or_create_class(@super_class)
        fun = supr.get_function name
        puts "#{supr.functions.collect(&:name)} for #{name} GOT #{fun.class}" if name == :index_of
      end
      raise "Method not found :#{name}, for #{inspect}" unless fun
      fun
    end

    def inspect
      "BootClass #{@name} < #{@super_class}:#{@functions.collect(&:name)}"
    end
    def to_s
      inspect
    end
    # Code interface follows. Note position is inheitted as is from Code

    # length of the class is the length of it's functions
    def length
      @functions.inject(0) {| sum  , item | sum + item.length}
    end
    
    # linking functions
    def link_at( start , context)
      super
      @functions.each do |function|
        function.link_at(start , context)
        start += function.length
      end
    end

    # assemble functions
    def assemble( io )
      @functions.each do |function|
        function.assemble(io)
      end
      io
    end
  end
end