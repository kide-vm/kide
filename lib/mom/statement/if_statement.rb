module Mom
  class IfStatement < Statement
    attr_reader :condition , :if_true , :if_false

    attr_accessor :hoisted

    def initialize( cond , if_true , if_false = nil)
      @condition = cond
      @if_true = if_true
      @if_false = if_false
      raise if_true.class unless if_true.is_a? Statement
    end

    def flatten(options = {})
      true_label = Label.new( "true_label_#{object_id}")
      false_label = Label.new( "false_label_#{object_id}")
      merge_label = Label.new( "merge_label_#{object_id}")
      first = condition.flatten( true_label: true_label , false_label: false_label)
      if hoisted
        head = hoisted.flatten
        head.append first
      else
        head = first
      end
      head.append true_label
      head.append if_true.flatten( merge_label: merge_label)
      if( if_false)
        head.append false_label
        head.append if_false.flatten( merge_label: merge_label)
      end
      head.append merge_label
      head
    end
  end

end
