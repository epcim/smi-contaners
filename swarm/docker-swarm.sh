#!/bin/bash
initialize_master() {
  #create_manager
  get_ip $1 $2
  echo $IP
  $DOCKER swarm init --advertise-addr $IP
}

join_master() {
  $DOCKER swarm join --token $1 $2
}

create_manager() {
  echo "Creating manager node via docker-machine..."
  test `which docker-machine` || { echo "docker-machine is not installed"; exit 1; }

}

get_ip() {
  export PATH="$(dirname $1)/../scripts:$PATH"
  eval `name-to-ip.sh $2`
  test -z "$IP" -o -z "$NAME" && exit 1
}

test `which docker` || { echo "Docker is not installed"; exit 1; }
DOCKER=`whereis docker | awk '{ print $2 }'`

case "$1" in
        master)
                initialize_master $0 $2
                exit 0 ;;
        worker)
                join_master $2 $3
                exit 0 ;;
        *)      echo "specify if host is master or worker. Run $0 [[master [hostname]]|[worker [master_join_hash] [master_ip:port]]]"
                exit 1 ;;
esac
