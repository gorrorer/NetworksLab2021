require "socket"
require_relative "msconst/MessageClass.rb"

$server = TCPServer.open("localhost", 2000)
$connections = Hash.new
$clients = Hash.new
$connections[:clients] = $clients
$name = "<server>"
$messageStack = []
$path = ""

def run
  loop {
    Thread.start($server.accept) do | client |
      nick_name = receive(client).header.username.pack("C*")
      STDOUT.puts "#{nick_name} #{client.peeraddr[2]}:#{client.peeraddr[1]} #{Thread.current}"
      serviceBroad(nick_name, "#{nick_name} connected")
      $connections[:clients][nick_name] = client
      service(client, "You're successfully connected'")
      listen_user_messages( nick_name, client, Thread.current )
    end
  }.join
end


def listen_user_messages( username, client, thread )
  loop {
    begin
      msg = receive(client)
    rescue
      client.close
      STDOUT.puts "#{username.to_s} disconnected"
      $connections[:clients].delete(username)
      serviceBroad(username, "#{username} disconnected")
      Thread.kill(thread)
    end
		transmit(username, msg)
  }
end

def serviceBroad(username, msg)

  if ($connections[:clients][username] == nil)
  	message = Message.new().gen(msg, $name, $path)
  	message.header.hours = [Time.now.hour]
 		message.header.minutes = [Time.now.min]
    $connections[:clients].each do |other_name, other_client|
  		other_client.print(message.message)
    end
  end
end

def receive(client)
  headerStr = client.read(32)
  header = MessageHeader.new().hunpack(headerStr)
  msg = client.read(header.messageSize.assemble)
  msg = Message.new().disassemble(headerStr+msg)
  return msg 
end

def transmit(username, msg)
	msg.header.hours = [Time.now.hour]
  msg.header.minutes = [Time.now.min]
	msg = msg.message
	$connections[:clients].each do |other_name, other_client|
     unless other_name == username
       other_client.print (msg)
    end
  end
end

def service(client, msg)
  message = Message.new().gen(msg, $name, $path)
  message.header.hours = [Time.now.hour]
  message.header.minutes = [Time.now.min]
  client.print(message.message)
end


run
