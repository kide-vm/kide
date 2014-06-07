# Make hash attributes to object attributes

module Support
  module HashAttributes
    # map any function call to an attribute if possible
    def method_missing name , *args , &block 
      if args.length > 1 or block_given?
        puts "NO -#{args.length} BLOCK #{block_given?}"
        super 
      else
        sname = name.to_s
        if args.length == 1        #must be assignemnt for ir attr= val
          if sname.include? "="
            #puts "setting :#{name.chop}:#{args[0]}"
            return @attributes[sname.chop.to_sym] = args[0]
          else 
            super
          end
        else
          #puts "getting :#{name}:#{@attributes[name.to_sym]}"
          return @attributes[sname.to_sym]
        end
      end
    end
  end
end
