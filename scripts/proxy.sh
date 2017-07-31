declare -r HTTP_PROXY='http://proxy.wdf.lab.corp:8080'
declare -r HTTPS_PROXY="$HTTP_PROXY"
declare -r FTP_PROXY="$HTTP_PROXY"
declare -r http_proxy="$HTTP_PROXY"
declare -r https_proxy="$HTTP_PROXY"
declare -r ftp_proxy="$HTTP_PROXY"
declare -r NO_PROXY='localhost,.lab,.corp,.ci,.cloud,169.254.169.254,127.0.0.1,127.0.0.2'
declare -r no_proxy="$NO_PROXY"

export HTTP_PROXY HTTPS_PROXY http_proxy https_proxy NO_PROXY no_proxy


