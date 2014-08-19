module Sof
  class Volotile
    @@mapping = {
      Virtual::Block =>  [:method],
      Virtual::MethodDefinition =>  [:current]
    }
    def self.attributes clazz
      @@mapping[clazz] || []
    end
  end
end
