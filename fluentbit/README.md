wget -qO - http://packages.fluentbit.io/fluentbit.key | sudo apt-key add -                          
echo "deb http://packages.fluentbit.io/ubuntu xenial main" > /etc/apt/sources.list.d/fluentbit.list
apt update
sudo apt-get install td-agent-bit -y

