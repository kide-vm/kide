module Sof
  class Known
    @@mapping = {
      MethodDefinition =>  [:name , :args , :receiver , :return_type , :blocks]
    }
    def self.is clazz
      @@mapping.has_key? clazz
    end
    def self.attributes clazz
      @@mapping[clazz]
    end
  end
end
