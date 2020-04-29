# !/bin/bash
nohup ruby TokenServer.rb > token_server_log.txt &
nohup ruby Queues.rb > q_server_log.txt &
ruby ProducerClient.rb > producer_log.txt &
ruby ConsumerClient.rb > consumer_log.txt &
