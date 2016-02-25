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
    include Logging
    log_level :info

    MARKER = 0xA51AF00D

    def initialize machine
      @machine = machine
      @load_at = 0x8054 # this is linux/arm
    end

    def assemble
      at = 0
      #need the initial jump at 0 and then functions
      @machine.init.set_position(at)
      at += @machine.init.byte_length
      at +=  8 # thats the padding
      # want to have the objects first in the executable
      @machine.objects.each do | id , objekt|
        next if objekt.is_a? Register::Label # will get assembled as method.instructions
        next if objekt.is_a? Parfait::BinaryCode
        objekt.position = at
        at += objekt.padded_length
      end
      # and then everything code
      @machine.objects.each do |id , objekt|
        next unless objekt.is_a? Parfait::Method
        objekt.binary.position = at
        objekt.instructions.set_position at + 12 # BinaryCode header
        len = objekt.instructions.total_byte_length
        log.debug "CODE #{objekt.name} at #{objekt.binary.position} len: #{len}"
        objekt.binary.set_length(len , 0)
        at += objekt.binary.padded_length
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
        next if objekt.is_a?(Register::Label)
        log.debug "Linked #{objekt.class}(#{objekt.object_id}) at #{objekt.position} / #{objekt.padded_length}"
        objekt.position
      end

      # first we need to create the binary code for the methods
      @machine.objects.each do |id , objekt|
        next unless objekt.is_a? Parfait::Method
        assemble_binary_method(objekt)
      end

      @stream = StringIO.new
      @machine.init.assemble( @stream )
      8.times do
        @stream.write_uint8(0)
      end

      #  then the objects , not code yet
      @machine.objects.each do | id, objekt|
        next if objekt.is_a? Parfait::BinaryCode
        next if objekt.is_a? Register::Label # ignore
        write_any( objekt )
      end

      # then write the methods to file
      @machine.objects.each do |id, objekt|
        next unless objekt.is_a? Parfait::BinaryCode
        write_any( objekt )
      end
      log.debug "Assembled #{stream_position} bytes"
      return @stream.string
    end

    # assemble the MethodSource into a stringio
    # and then plonk that binary data into the method.code array
    def assemble_binary_method method
      stream = StringIO.new
      #puts "Method #{method.source.instructions.to_ac}"
      begin
        #puts "assemble #{method.source.instructions}"
        method.instructions.assemble_all( stream )
      rescue => e
        log.debug "Assembly error #{method.name}\n#{Sof.write(method.instructions).to_s[0...2000]}"
        raise e
      end
      index = 1
      stream.rewind
      log.debug "Assembled code #{method.name} with length #{stream.length}"
      raise "length error #{method.binary.char_length} != #{method.instructions.total_byte_length}" if method.binary.char_length != method.instructions.total_byte_length
      raise "length error #{stream.length} != #{method.instructions.total_byte_length}" if method.instructions.total_byte_length != stream.length
      stream.each_byte do |b|
        method.binary.set_char(index , b )
        index = index + 1
      end
    end

    def write_any obj
      log.debug "Write #{obj.class}(#{obj.object_id}) at stream #{stream_position} pos:#{obj.position} , len:#{obj.padded_length}"
      if @stream.length != obj.position
        raise "Write #{obj.class} #{obj.object_id} at #{stream_position} not #{obj.position}"
      end
      if obj.is_a?(Parfait::Word) or obj.is_a?(Symbol)
        write_String obj
      else
        write_object obj
      end
      log.debug "Wrote #{obj.class}(#{obj.object_id}) at stream #{stream_position} pos:#{obj.position} , len:#{obj.padded_length}"
      obj.position
    end

    # write type and type of the instance, and the variables that are passed
    # variables ar values, ie int or refs. For refs the object needs to save the object first
    def write_object( object )
      log.debug "Write object #{object.class} #{object.inspect}"
      unless @machine.objects.has_key? object.object_id
        raise "Object(#{object.object_id}) not linked #{object.inspect}"
      end
      @stream.write_sint32( MARKER  )
      written = 0 # compensate for the "secrect" marker
      object.get_instance_variables.each do |var|
        inst = object.get_instance_variable(var)
        #puts "Nil for #{object.class}.#{var}" unless inst
        write_ref_for(inst)
        written += 4
      end
      lay_len = written
      log.debug "instances=#{object.get_instance_variables.inspect} mem_len=#{object.padded_length}"
      if( object.is_a? Parfait::Indexed)
        object.each do |inst|
          write_ref_for(inst)
          written += 4
        end
      end
      log.debug "type #{lay_len} , total #{written} (array #{written - lay_len})"
      log.debug "Len = #{object.get_length} , inst = #{object.get_type.instance_length}" if object.is_a? Parfait::Type
      pad_after( written  )
      object.position
    end

    def write_BinaryCode code
        write_String code
    end

    def write_String( string )
      if string.is_a? Parfait::Word
        str = string.to_string
        raise "length mismatch #{str.length} != #{string.char_length}" if str.length != string.char_length
      end
      str = string.to_s if string.is_a? Symbol
      log.debug "#{string.class} is #{string} at #{string.position} length #{string.length}"
      @stream.write_sint32( MARKER  )
      write_ref_for( string.get_type ) #ref
      @stream.write_sint32( str.length  ) #int
      @stream.write str
      pad_after(str.length + 8 ) # type , length   *4 == 12
      log.debug "String (#{string.length}) stream #{@stream.length}"
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
        @stream.write_sint32(0)
      when Fixnum
        @stream.write_sint32(object)
      else
        @stream.write_sint32(object.position + @load_at)
      end
    end

    # pad_after is always in bytes and pads (writes 0's) up to the next 8 word boundary
    def pad_after length
      before = stream_position
      pad = padding_for(length) - 4  # four is for the MARKER we write
      pad.times do
        @stream.write_uint8(0)
      end
      after = stream_position
      log.debug "padded #{length} with #{pad} stream #{before}/#{after}"
    end

    # return the stream length as hex
    def stream_position
      @stream.length
    end
  end

  Sof::Volotile.add(Assembler , [:objects])
end
