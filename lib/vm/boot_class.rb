module Vm
  # class is mainly a list of functions with a name (for now)
  # layout of object is seperated into Layout
  class BootClass < Code
    def initialize name , context
      @context = context
      # class functions
      @functions = []
      @name = name.to_sym
    end
    attr_reader :name , :functions
    
    def add_function function
      raise "not a function #{function}" unless function.is_a? Function
      raise "syserr " unless function.name.is_a? Symbol
      @functions << function
    end

    def get_function name
      name = name.to_sym
      @functions.detect{ |f| f.name == name }
    end

    # preferred way of creating new functions (also forward declarations, will flag unresolved later)
    def get_or_create_function name 
      fun = get_function name
      unless fun
        fun = Core::Kernel.send(name , @context)
        raise "no such function #{name}, #{name.class}" if fun == nil
        @functions << fun
      end
      fun
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