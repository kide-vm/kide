module Sof
  class Volotile
    @@mapping = {
      Virtual::MethodDefinition =>  [:current]
    }
    def self.attributes clazz
      @@mapping[clazz] || []
    end
  end
end
