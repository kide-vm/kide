module Mom
  class IfStatement < Statement
    attr_reader :condition , :if_true , :if_false

    attr_accessor :hoisted

    def initialize( cond , if_true , if_false = nil)
      @condition = cond
      @if_true = if_true
      @if_false = if_false
    end

    def flatten
      head = hoisted.flatten
      true_label = Label.new( "true_label_#{object_id}")
      false_label = Label.new( "false_label_#{object_id}")
      merge_label = Label.new( "merge_label_#{object_id}")
      head.append condition.flatten( true_label: true_label , false_label: false_label)
      head.append true_label
      head.append if_true.flatten( merge_label: merge_label)
      head.append false_label
      head.append if_false.flatten( merge_label: merge_label)
      head.append merge_label
      head
    end
  end

end
