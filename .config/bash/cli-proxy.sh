assignProxy() {
    PROXY_ENV="http_proxy ftp_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY ALL_PROXY"
    for envar in $PROXY_ENV; do
        export "$envar"="$1"
    done

    NO_PROXY_ENV="no_proxy NO_PROXY"
    for envar in $NO_PROXY_ENV; do
        export "$envar"="$2"
    done
}
clrProxy() {
    PROXY_ENV="http_proxy ftp_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY ALL_PROXY"
    for envar in $PROXY_ENV; do
        unset "$envar"
    done
}

# usage: myProxy 127.0.0.1:7890
myProxy() {
    # user=YourUserName
    # read -p "Password: " -s pass &&  echo -e " "
    # proxy_value="http://$user:$pass@ProxyServerAddress:Port"
    local usage="usage: myProxy [IP:Port]"
    local default_proxy="127.0.0.1:7890"
    local proxy_pattern="^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+$"

    case $# in
    0) proxy_array=$default_proxy ;;
    1) if [[ $1 =~ $proxy_pattern ]]; then
        proxy_array=$1
    else
        echo "$usage"
        return 1
    fi ;;
    *)
        echo "$usage"
        return 1
        ;;
    esac

    proxy_value="http://$proxy_array"
    no_proxy_value="localhost,127.0.0.1,LocalAddress,LocalDomain.com"
    assignProxy "$proxy_value" "$no_proxy_value"
    echo "proxy server $proxy_array activated"
}
