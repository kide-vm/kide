AST::Node.class_eval do

  def [](name)
    #puts self.inspect
    children.each do |child|
      if child.is_a?(AST::Node)
        #puts child.type
        if (child.type == name)
          return child.children
        end
      else
        #puts child.class
      end
    end
    nil
  end

  def first_from( node_name )
    from = self[node_name]
    return nil unless from
    from.first
  end
end
