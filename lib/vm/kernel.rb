module Vm
  module Kernel
    def self.start
      #TODO extract args into array of strings
    end
    def self.exit
      # Machine.exit swi 0 
    end
    def self.puts
      "me"
    end
  end
end