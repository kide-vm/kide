module Vool
  module Builtin
    def self.boot_methods(options)
      return if options[:boot_methods] == false
      load_builtin( :int_plus )
    end

    def self.load_builtin(name)
      fname = "./builtin/#{name}.rb"
      File.read File.expand_path(fname, File.dirname(__FILE__))
    end
  end
end
