module Vm
  module Assignment

    def on_IvarAssignment( statement )
      value = assignment_value(statement)
      name = check_name(statement.name.name)
      index = @method.for_type.variable_index( name)
      raise "No such ivar #{name}  #{@method.for_type}" unless index
      value_type = @method.for_type.type_at( index )
      raise "Argument Type mismatch #{value.type}!=#{value_type}" unless value.type == value_type
      value_reg = use_reg(:value_type)
      add_slot_to_reg(statement , :message , :receiver , value_reg )
      add_reg_to_slot(statement , value , value_reg , index + 1 ) # one for type
    end

    def on_LocalAssignment( statement )
      do_assignment_for( statement , :local )
    end

    def on_ArgAssignment( statement )
      do_assignment_for( statement , :argument )
    end

    private

    def do_assignment_for( statement , type )
      value = assignment_value(statement)
      name = check_name(statement.name.name)
      index = @method.send( "has_#{type}" , name)
      raise "No such #{type} #{name}  #{@method.inspect}" unless index
      value_type = @method.send("#{type}s_type" , index )
      raise "Argument Type mismatch #{value.type}!=#{value_type}" unless value.type == value_type
      move_reg(statement , "#{type}s".to_sym , value , index)
    end

    def move_reg(statement , type , value , index)
      named_list = use_reg(:NamedList)
      add_slot_to_reg(statement , :message , type , named_list )
      add_reg_to_slot(statement , value , named_list , index + 1 ) # one for type
    end

    def assignment_value(statement)
      reset_regs # statements reset registers, ie have all at their disposal
      value = process(statement.value)
      raise "Not register #{v}" unless value.is_a?(Register::RegisterValue)
      value
    end
    # ensure the name given is not space and raise exception otherwise
    # return the name
    def check_name( name )
      raise "space is a reserved name" if name == :space
      name
    end

  end
end
