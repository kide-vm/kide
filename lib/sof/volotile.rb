module Sof
  class Volotile
    @@mapping = {
      Virtual::MethodDefinition =>  []
    }
    def self.attributes clazz
      @@mapping[clazz] || []
    end
  end
end
