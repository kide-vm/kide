module Sof
  class Volotile
    @@mapping = {
      Virtual::Block =>  [:method],
      Virtual::CompiledMethod =>  [:current]
    }
    def self.attributes clazz
      @@mapping[clazz] || []
    end
    def self.add clazz , attributes
      @@mapping[clazz] = attributes
    end
  end
end
