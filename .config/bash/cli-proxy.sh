assignProxy(){
    PROXY_ENV="http_proxy ftp_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY ALL_PROXY"
    for envar in $PROXY_ENV
    do
        export "$envar"="$1"
    done

    NO_PROXY_ENV="no_proxy NO_PROXY"
    for envar in $NO_PROXY_ENV
    do
        export "$envar"="$2"
    done
}
clrProxy(){
    PROXY_ENV="http_proxy ftp_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY ALL_PROXY"
    for envar in $PROXY_ENV
    do
        unset "$envar"
    done
}

# usage: myProxy 127.0.0.1:1080
myProxy(){
    # user=YourUserName
    # read -p "Password: " -s pass &&  echo -e " "
    # proxy_value="http://$user:$pass@ProxyServerAddress:Port"
    if [ $# == 0 ]
    then
        proxy_array=127.0.0.1:1080
    elif [ $# == 1 ]
    then
        proxy_array=$1
    else
        echo "Usage: myProxy [ProxyServerAddress:Port]"
        return 1
    fi

    proxy_value="http://$proxy_array"
    no_proxy_value="localhost,127.0.0.1,LocalAddress,LocalDomain.com"
    assignProxy "$proxy_value" "$no_proxy_value"
    echo "proxy server $proxy_array activated"
}
