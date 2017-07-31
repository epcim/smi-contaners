

DOCKER_SERVICES="$(docker network inspect --format '{{range $key, $val := .Containers}} {{$key}}|{{$val.IPv4Address}}{{end}}' docker_gwbridge | xargs -d' ' -I{} echo {} | tr "|" " " | xargs -l bash -c 'ip=$1; name=`docker ps --format {{.Names}} -f id=$0`; if [[ ! -z $name ]]; then echo "${ip//\/*} ${name//.*}\\\n"; fi' |xargs)"

cp /etc/hosts /etc/hosts.docker-pre
sed -n '/#DOCKER_SERVICES_START/{p;:a;N;/#DOCKER_SERVICES_END/!ba;s/.*\n/'"${DOCKER_SERVICES// 1/1}"'/};p' /etc/hosts | tee /etc/hosts.docker
cp /etc/hosts.docker /etc/hosts
