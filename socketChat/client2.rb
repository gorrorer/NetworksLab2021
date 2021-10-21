require "socket"
require_relative "msconst/MessageClass.rb"

class TCPClient

  def initialize(ip, port, username)
    @server = TCPSocket.open(ip, port)
  end

  def receive
    headerStr = @server.read(32)
    header = MessageHeader.new().hunpack(headerStr)
    msg = @server.read(header.messageSize.assemble)
    msg = Message.new().disassemble(headerStr+msg)
    #msg.servicePrint
    return msg
    
  end

  def transmit(msg, username, path)
    message = Message.new().gen(msg, username, path)
    #message.servicePrint
    message = message.message
    @server.print(message)
  end

end    #class end


