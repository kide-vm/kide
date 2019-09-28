module Util

  module CompilerList

    attr_reader :next_compiler

    def add_method_compiler(comp)
      raise "not compiler #{comp.class}" unless comp.respond_to?(:find_compiler)
      raise "nil compiler #{self}" unless comp
      if(@next_compiler)
        @next_compiler.add_method_compiler(comp)
      else
        @next_compiler = comp
      end
    end

    def each_compiler &block
      block.yield(self)
      @next_compiler.each_compiler(&block) if @next_compiler
    end

    def find_compiler_name name
      return self if @callable.name == name
      return nil unless @next_compiler
      @next_compiler.find_compiler_name(name)
    end

    def find_compiler &block
      return self if block.yield(self)
      @next_compiler.find_compiler(&block) if @next_compiler
    end

    def last_compiler
      return self unless @next_compiler
      @next_compiler.last_compiler
    end

    def num_compilers
      1 + (@next_compiler ? @next_compiler.num_compilers : 0)
    end

  end
end
