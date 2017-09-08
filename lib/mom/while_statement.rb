
module Mom
  class WhileStatement < Statement
    attr_reader :condition , :statements

    attr_accessor :hoisted

    def initialize( cond , statements)
      @condition = cond
      @statements = statements
    end

    def flatten
      cond_label = Label.new( "cond_label_#{object_id}")
      head = cond_label
      head.append hoisted.flatten
      merge_label = Label.new( "merge_label_#{object_id}")
      head.append condition.flatten( true_label: cond_label , false_label: merge_label)
      head.append merge_label
      head
    end

  end

end
