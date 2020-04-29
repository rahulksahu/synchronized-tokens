require 'monitor'
require 'socket'
require_relative 'constants'

class Counter < Monitor
  def initialize
    @token = 0
    super
  end

  def next_token
    synchronize do
      @token += 1
    end
  end
end

def main port
  # kill already running server
  system("kill -9 $(lsof -i:#{port} -t) 2> /dev/null")

  counter = Counter.new
  token_server = TCPServer.open(port)

  # runs forever
  loop{
    Thread.start(token_server.accept) do |client|
      client_thread = client.recv(10) # producer index
      token = counter.next_token
      client.puts(token)
      p "Token: #{token}, Producer: #{client_thread}"
      client.close
    end
  }
end

main(T_PORT)