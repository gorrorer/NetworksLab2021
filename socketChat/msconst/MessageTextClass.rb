
class MessageText

  attr_accessor :messageStr
  attr_accessor :messageBytes
  attr_accessor :messageStrSize

  def gen(msg)
  	if msg.nil?
  		@messageStrSize = 0
  		@messageBytes = []
  		@messageStr = ""
  	else
  		@messageStrSize = msg.length()
  		@messageStr = msg
    	@messageBytes = @messageStr.unpack("C*")
  	end
    return self
  end
  
  def servicePrintFull
    STDOUT.puts("Message text: " + @messageStr)
    STDOUT.puts("Message bytes: " + @messageBytes)
    STDOUT.puts("Message byte size: " + @messageBytes.size.to_s)
    STDOUT.puts("Message string size: " + @messageStr.length.to_s)
  end
  
  def servicePrintShort
    STDOUT.puts("Message text: " + @messageStr)
    STDOUT.puts("Message string size: " + @messageStr.length.to_s)
    STDOUT.puts("Message byte size: " + @messageBytes.size.to_s)
  end

end
