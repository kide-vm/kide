require "fiddle"

class Integer
  def m
    address = Intel::Address.new
    address.offset = self
    address
  end

  def inspect
    "0x#{to_s 16}"
  end if $DEBUG
end
class Array
  def second
    self[1]
  end

  def push_D integer
    self.push(*[integer].pack("V").unpack("C4"))
  end

  def push_B integer
    self << (integer & 255)
  end

  def push_W integer
    self.push((integer & 255), (integer >> 8 & 255))
  end
end

ASM = []


class Object
  def assemble arg_count = 0, &block
    asm = Intel::MachineCodeX86.new

    # TODO: enter?
    asm.ebp.push
    asm.ebp.mov asm.esp

    size = asm.stream.size

    asm.instance_eval(&block)

    if asm.stream.size == size  # return nil
      warn "returning nil for #{self}##{name}"
      asm.eax.mov 4
    end

    asm.leave
    asm.ret

    code = asm.stream.pack("C*")

    if $DEBUG then
      path = "#{$$}.obj"
      File.open path, "wb" do |f|
        f.write code
      end

      puts code.unpack("C*").map { |n| "%02X" % n }.join(' ')
      system "ndisasm -u #{path}"

      File.unlink path
    end

    code
  end

  @@asm = {}
  def asm(name, *args, &block)
    code = @@asm[name] ||= assemble(&block).to_ptr

    return execute_asm(code) # code is the function pointer, wrapped
  end

#  defasm :execute_asm, :code do
#    eax.mov ebp + 0x0c # grab code
#    eax.mov eax + 0x10 # unwrap function pointer field
#    eax.mov eax.m      # dereference the pointer
#    eax.call           # call the function pointer
#  end
end
