require 'socket'
require 'securerandom'
require 'json'
require_relative 'constants'

def main producer_count, queue_count, token_port, q_port
	producer_count.times.map do |i|
		# starts a new producer thread
		Thread.new do
			queue_count.times do
				sleep(rand(queue_count))
				
				# get next token from token server
				token_socket = TCPSocket.open('localhost', token_port)
				token_socket.print(i+1)
				token = token_socket.gets.chop.to_i
				p "Producer: #{i+1}, Token Received: #{token}"
				token_socket.close
				
				# create random data
				data = SecureRandom.hex(5) + "-$" + token.to_s
				q_packet = {q_index: rand(queue_count), data: data, token: token, producer: i+1}
				
				# push random to queue server
				q_socket = TCPSocket.open('localhost', q_port)
				q_socket.print(q_packet.to_json)
				p "Producer: #{i+1}, Msg to MQ: #{q_packet.to_json}"
				q_socket.close
			end
		end
	end.each(&:join) # waits for all thread to complete
end

main(P_COUNT, Q_COUNT, T_PORT, Q_PORT)
