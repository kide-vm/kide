module Parfait
  class Variable < Object

    def initialize type , name , value = nil
      raise "not type #{type}(#{type.class})" unless Register.machine.space.get_class_by_name(type)
      self.type , self.name , self.value = type , name , value
      self.value = 0 if self.type == :Integer and value == nil
      raise "must give name for variable" unless name
    end
    attributes [:type , :name, :value]

    def to_s
      "Variable(#{self.type} ,#{self.name})"
    end
    def inspect
      to_s
    end
  end
end
