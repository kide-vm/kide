module Parfait
  class Variable < Object

    def initialize type , name , value = nil
      raise "not type #{type}(#{type.class})" unless Register.machine.space.get_class_by_name(type)
      self.value_type , self.name , self.value = type , name , value
      self.value = 0 if self.value_type == :Integer and value == nil
      raise "must give name for variable" unless name
    end
    attributes [:value_type , :name, :value]

    def to_s
      "Variable(#{self.value_type} ,#{self.name})"
    end
    def inspect
      to_s
    end
  end
end
