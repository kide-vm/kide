
module Mom
  class WhileStatement < Statement
    attr_reader :condition , :statements

    attr_accessor :hoisted

    def initialize( cond , statements)
      @condition = cond
      @statements = statements
    end

    def flatten(options = {})
      merge_label = Label.new( "merge_label_#{object_id}")
      cond_label = Label.new( "cond_label_#{object_id}")
      @nekst = cond_label
      @nekst.append(hoisted.flatten) if hoisted
      @nekst.append condition.flatten( true_label: cond_label , false_label: merge_label)
      @nekst.append merge_label
      @nekst
    end

  end

end
