# Make hash attributes to object attributes

module Support
  module HashAttributes
    # map any function call to an attribute if possible
    def method_missing name , *args , &block 
      if args.length > 1 or block_given?
        puts "NO -#{args.length} BLOCK #{block_given?}"
        super 
      else
        name = name.to_s
        if args.length == 1        #must be assignemnt for ir attr= val
          if name.include? "="
            return @attributes[name.chop] = args[0]
          else 
            super
          end
        else
          return @attributes[name]
        end
      end
    end
  end
end