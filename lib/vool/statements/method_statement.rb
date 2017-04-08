module Vool
  class MethodStatement < Statement
    attr_reader :name, :args , :body , :clazz

    def initialize( name , args , body)
      @name , @args , @body = name , args , (body || [])
    end

    def collect(arr)
      @body.collect(arr)
      super
    end

    def set_class(clazz)
      @clazz = clazz
    end

    def create_objects
      args_type = make_type
      locals_type = make_locals
      method = Rubyx::RubyMethod.new(name , args_type , locals_type , body )
      @clazz.add_method( method )
      #      compile_methods(clazz,methods)
    end

    private

    def make_type(  )
      type_hash = {}
      @args.each {|arg| type_hash[arg.children[0]] = :Object }
      Parfait::NamedList.type_for( type_hash )
    end

    def make_locals
      type_hash = {}
      vars = []
      @body.collect([]).each { |node| node.add_local(vars) }
      vars.each { |var| type_hash[var] = :Object }
      Parfait::NamedList.type_for( type_hash )
    end

    def create_methods(clazz , body)
      methods = Passes::MethodCollector.new.collect(body)
      methods.each do |method|
        clazz.add_method( method )
        normalizer = Passes::Normalizer.new(method)
        method.normalize_source { |sourc| normalizer.process( sourc ) }
      end
      methods
    end

    def compile_methods(clazz , methods)
      methods.each do |method|
        code = Passes::MethodCompiler.new(method).get_code
        typed_method = method.create_vm_method(clazz.instance_type)
        Vm::MethodCompiler.new( typed_method ).init_method.process( code )
      end
    end

  end
end
