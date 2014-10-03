module Sof
  class Volotile
    @@mapping = {    }
    def self.attributes clazz
      @@mapping[clazz] || []
    end
    def self.add clazz , attributes
      @@mapping[clazz] = attributes
    end
  end
end
