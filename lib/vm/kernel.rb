module Vm
  module Kernel
    def self.start
      #TODO extract args into array of strings
      Machine.instance.main_entry
    end
    def self.exit
      # Machine.exit swi 0 
      Machine.instance.main_exit
    end
    def self.puts string
      # should unwrap from string to char*
      Machine.instance.puts string
    end
  end
end