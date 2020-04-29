# synchronized-tokens

### TokenServer
a multithreaded tcp server which accepts requests from producers to provide synchronized tokens.

### Queues
set of simple fifo queues with a multithreaded tcp server and min_heap implementation. Functions :-
- accepts tcp requests from producers to push data into different queues.
- accepts tcp requests from consumers to provide current first entry in overall queues.

### ProducerClient
a multithreaded tcp client which :-
- connects with token_server to get next token.
- sends random data to queue_server at random timestamps with token and queue_index.

### ConsumerClient
a multithreaded tcp client which connects with queue_server to consume next entry.

### min_heap
heap implementation to find next entry with min token from set of queues.

### constants
values for all ports and number of producers/consumers/queues

### run.sh
shell script to start all servers/clients and log their actions in log files
