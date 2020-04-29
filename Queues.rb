require 'socket'
require 'json'
require_relative 'min_heap'
require_relative 'constants'

class MQs
  attr_reader :queues, :p_queue

  def initialize q_count
    @queues = Array.new(q_count){|i| []}
    @p_queue = MinHeap.new
  end

  def push data
    if @queues[data["q_index"]].empty? # push first entry to heap 
    	@p_queue << data
    else
	    @queues[data["q_index"]].push(data)
    end
  end

  def pop
  	data = @p_queue.pop
  	if !data.nil?
	  	to_enq = @queues[data["q_index"]].shift
	  	@p_queue << to_enq if !to_enq.nil?
	  end
	  return (data || {})["data"]
  end
end

def main q_port, q_count
  # kill already running server
	system("kill -9 $(lsof -i:#{q_port} -t) 2> /dev/null")

	mq = MQs.new(q_count)
	p_server = TCPServer.open(q_port)

  # runs forever
	loop{
    Thread.start(p_server.accept) do |client|
    	client_data = client.recv(100)
    	if client_data[0..1] == "C_" # identifier b/w consumer and producer requests
    		data_to_send = mq.pop
    		c_index = client_data.split("_").last # consumer index
    		p "Consumer: #{c_index}, Data Sent: #{data_to_send}"
	    	client.puts(data_to_send.to_s)
    	else
	      q_data = JSON.parse(client_data)
	      p_index = q_data.delete("producer") # producer index
	      mq.push(q_data)
	      p "Pushed: #{q_data.to_json}, Producer: #{p_index}"
    	end
      client.close
    end
  }
end

main(Q_PORT, Q_COUNT)