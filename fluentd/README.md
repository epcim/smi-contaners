

# Client configuration
Install Fluentbit on a client

## from rpm repo, on suse

> cat <<-EOF > /etc/zypp/repos.d/td-agent-bit.repo
> 	[td-agent-bit]
> 	name=TD Agent Bit
> 	enabled=1
> 	autorefresh=0
> 	baseurl=http://packages.fluentbit.io/centos/7
> 	type=rpm-md
> 	gpgcheck=1
> 	gpgkey=http://packages.fluentbit.io/fluentbit.key
> EOF
> 
> zypper refresh -r 'TD Agent Bit'
> 
> zypper install -y td-agent-bit

## configure

Under /etc/td-agent-bit/*.conf

> [INPUT]
>     Name cpu
>     Tag  cpu.local
> 
> [INPUT]
>     Name   kmsg
>     Tag    kernel
> 
> [INPUT]
>     Name   tail
>     Path   /var/log/messages
>     Tag    system.log.messages
> 
> [OUTPUT]
>     Name  es
>     Match system.** cpu.** disk.** memory.** kernel.**
>     #Host  172.18.0.4
>     Host  cis_elasticsearch
>     Port  9200
>     Index fluentbit_system
>     Type  fluentbit
> 
> [OUTPUT]
>     Name          forward
>     Match         *
>     #Host         172.18.0.5
>     Host          cis_fluent
>     Port          24224
>     Self_Hostname monitor-node3.local
> 

# Backend configuration
Run fluentd daemon in a container.

Follow the steps to BUILD THE CUSTOM CONTAINER.
In the main directory of repo is a docker-compose file used to deploy whole CIS stack.

## add/init submodule
> cd <repo>/fluent
> git submodule add https://github.com/fluent/fluentd-docker-image
> git submodule init --recursive

## update Dockerfile
> vim fluentd-docker-image/v0.14/alpine/Dockerfile

### add plugins, ~line 30
> && gem install fluent-plugin-elasticsearch \
> && gem install fluent-plugin-mail \

### build

> source scripts/proxy.sh
> # or
> HTTP_PROXY=http://proxy.wdf.lab.corp:8080
> HTTPS_PROXY=$HTTP_PROXY
> https_proxy=$HTTP_PROXY
> http_proxy=$HTTP_PROXY
> export HTTP_PROXY HTTPS_PROXY http_proxy https_proxy

> cd fluentd-docker-image/v0.12/alpine/Dockerfile
> docker build \
> "--build-arg=HTTP_PROXY=$HTTP_PROXY" \
> "--build-arg=http_proxy=$HTTP_PROXY" \
> "--build-arg=HTTPS_PROXY=$HTTP_PROXY" \
> "--build-arg=https_proxy=$HTTP_PROXY" \
> "--build-arg=NO_PROXY=$NO_PROXY" \
> "--build-arg=no_proxy=$NO_PROXY" \
> -t lab-fluentd:latest ./


### upload to regisry

Prereq:
> {
>   "log-opts": {
>     "max-size": "50m"
>   },
>   "insecure-registries": [
>     "172.16.10.253:5000",
>     "172.16.10.253:15000",                
>     "172.16.10.107:15000",                
>     "mon01.virtual-mcp11-ovs.local:15000",
>     "mon01.virtual-mcp11-ovs.local:5000"
>   ],
>   "log-driver": "json-file"
> }
> systemctl restart docker 

tag and push:
> docker tag 0a6f1b2ca9a2 mon01.virtual-mcp11-ovs.local:15000/lab-fluentd:latest 
> docker push mon01.virtual-mcp11-ovs.local:15000/lab-fluentd:latest

  
