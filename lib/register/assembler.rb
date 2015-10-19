module Register
  class LinkException < Exception
  end
  # Assemble the object machine into a binary.
  # Assemble first to get positions, then write

  # The assemble function determines the length of an object and then actually
  #  writes the bytes they are pretty much dependant. In an earlier version they were
  #  functions on the objects, but now it has gone to a visitor pattern.

  class Assembler
    include Padding
    TYPE_REF =  0
    TYPE_INT =  1
    TYPE_BITS = 4
    TYPE_LENGTH = 6

    def initialize machine
      @machine = machine
      @load_at = 0x8054 # this is linux/arm
    end

    def assemble
      at = 0
      # want to have the methods first in the executable
      # so first we determine the code length for the methods and set the
      # binary code (array) to right length
      @machine.objects.each do |id , objekt|
        next unless objekt.is_a? Parfait::Method
        # should be fill_to_length (with zeros)
        objekt.code.set_length(objekt.source.byte_length , 0)
      end
      #need the initial jump at 0 and then functions
      @machine.init.set_position(at)
      at += @machine.init.byte_length
      at +=  8 # thats the padding

      # then we make sure we really get the binary codes first
      @machine.objects.each do |id , objekt|
        next unless objekt.is_a? Parfait::BinaryCode
        objekt.set_position at
        #puts "CODE #{objekt.name} at #{objekt.position}"
        at += objekt.word_length
      end
      # and then everything else
      @machine.objects.each do | id , objekt|
        # have to tell the code that will be assembled where it is to
        # get the jumps/calls right
        if objekt.is_a? Parfait::Method
          objekt.source.set_position( objekt.code.position )
        end
        next if objekt.is_a? Parfait::BinaryCode
        objekt.set_position at
        at += objekt.word_length
      end
    end

    def write_as_string
      # must be same order as assemble
      begin
        return try_write
      rescue LinkException
        # knowing that we fix the problem, we hope to get away with retry.
        retry
      end
    end

    # private method to implement write_as_string. May throw link Exception in which
    # case we try again. Once.
    def try_write
      assemble
      all = @machine.objects.values.sort{|a,b| a.position <=> b.position}
      # debugging loop accesses all positions to force an error if it's not set
      all.each do |objekt|
        #puts "Linked #{objekt.class}(#{objekt.object_id.to_s(16)}) at #{objekt.position.to_s(16)} / #{objekt.word_length.to_s(16)}"
        objekt.position
      end
      # first we need to create the binary code for the methods
      @machine.objects.each do |id , objekt|
        next unless objekt.is_a? Parfait::Method
        assemble_binary_method(objekt)
      end
      @stream = StringIO.new
      @machine.init.codes.each do |code|
        code.assemble( @stream )
      end
      8.times do
        @stream.write_uint8(0)
      end

      # then write the methods to file
      @machine.objects.each do |id, objekt|
        next unless objekt.is_a? Parfait::BinaryCode
        write_any( objekt )
      end
      # and then the rest of the object machine
      @machine.objects.each do | id, objekt|
        next if objekt.is_a? Parfait::BinaryCode
        write_any( objekt )
      end
      #puts "Assembled #{stream_position} bytes"
      return @stream.string
    end

    # assemble the MethodSource into a stringio
    # and then plonk that binary data into the method.code array
    def assemble_binary_method method
      stream = StringIO.new
      method.source.blocks.each do |block|
        block.codes.each do |code|
          begin
            code.assemble( stream )
          rescue => e
            puts "Assembly error #{method.name}\n#{Sof.write(method.source.blocks).to_s[0...2000]}"
            puts Sof.write(code)
            raise e
          end
        end
      end
      method.code.fill_with 0
      index = 1
      stream.rewind
      #puts "Assembled #{method.name} with length #{stream.length}"
      raise "length error #{method.code.length} != #{method.source.byte_length}" if method.code.length != method.source.byte_length
      raise "length error #{stream.length} != #{method.source.byte_length}" if method.source.byte_length != stream.length
      stream.each_byte do |b|
        method.code.set_char(index , b )
        index = index + 1
      end
    end

    def write_any obj
      #puts "Assemble #{obj.class}(#{obj.object_id.to_s(16)}) at stream #{stream_position} pos:#{obj.position.to_s(16)} , len:#{obj.word_length.to_s(16)}"
      if @stream.length != obj.position
        raise "Assemble #{obj.class} #{obj.object_id.to_s(16)} at #{stream_position} not #{obj.position.to_s(16)}"
      end
      if obj.is_a?(Parfait::Word) or obj.is_a?(Symbol)
        write_String obj
      else
        write_object obj
      end
      obj.position
    end

    def type_word array
      word = 0
      index = 0
      array.each do |var |
        #type = (var.class == Integer) ? TYPE_INT : TYPE_REF
        #TODO
        type = TYPE_REF
        word += type << (index * TYPE_BITS)
        index = index + 1
      end
      word += ( (array.get_length + 1 ) / 8 ) << TYPE_LENGTH * TYPE_BITS
      word
    end

    # write type and layout of the instance, and the variables that are passed
    # variables ar values, ie int or refs. For refs the object needs to save the object first
    def write_object( object )
      unless @machine.objects.has_key? object.object_id
        raise "Object(#{object.object_id}) not linked #{object.inspect}"
      end
      layout = object.get_layout
      type = type_word(layout)
      @stream.write_uint32( type )
      write_ref_for(layout )
      layout.each do |var|
        inst = object.instance_variable_get "@#{var}".to_sym
        #puts "Nil for #{object.class}.#{var}" unless inst
        write_ref_for(inst)
      end
      #puts "layout length=#{layout.get_length.to_s(16)} mem_len=#{layout.word_length.to_s(16)}"
      l = layout.get_length
      if( object.is_a? Parfait::List)
        object.each do |inst|
          write_ref_for(inst)
        end
        l += object.get_length
      end
      pad_after( l * 4)
      object.position
    end

    def write_BinaryCode code
        write_String code
    end

    def write_String( string )
      str = string.to_string if string.is_a? Parfait::Word
      str = string.to_s if string.is_a? Symbol
      word = (str.length + 7) / 32  # all object are multiple of 8 words (7 for header)
      # first line is integers, convention is that following lines are the same
      TYPE_LENGTH.times { word = ((word << TYPE_BITS) + TYPE_INT) }
      @stream.write_uint32( word )
      #puts "String is #{string} at #{string.position.to_s(16)} length #{string.length}"
      write_ref_for( string.get_layout ) #ref
      @stream.write str
      pad_after(str.length)
      #puts "String (#{string.length.to_s(16)}) stream #{@stream.length.to_s(16)}"
    end

    def write_Symbol(sym)
      return write_String(sym)
    end

    private

    # write means we write the resulting address straight into the assembler stream
    # object means the object of which we write the address
    def write_ref_for object
      case object
      when nil
        pos = 0 - @load_at
      when Fixnum
        pos = object - @load_at
      else
        pos =  object.position
      end
      @stream.write_sint32(pos + @load_at)
    end

    # pad_after is always in bytes and pads (writes 0's) up to the next 8 word boundary
    def pad_after length
      before = stream_position
      pad = padding_for(length)
      pad.times do
        @stream.write_uint8(0)
      end
      after = stream_position
      #puts "padded #{length.to_s(16)} with #{pad.to_s(16)} stream #{before}/#{after}"
    end

    # return the stream length as hex
    def stream_position
      @stream.length.to_s(16)
    end
  end

  Sof::Volotile.add(Register::Assembler , [:objects])
end
