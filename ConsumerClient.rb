require 'socket'
require_relative 'constants'

def main q_port, c_count
	c_count.times.map do |i|
		# creates a new thread
		Thread.new do
			sleep(rand(c_count))

			# connects with queue server to consume next entry
			socket = TCPSocket.open('localhost', q_port)
			socket.print("C_#{i+1}")
			while q_data = socket.gets
				p "Consumer: #{i+1}, Msg Recieved: #{q_data.chop}"
			end
			socket.close
		end
	end.each(&:join) # waits for all thread to complete
end

main(Q_PORT, C_COUNT)
