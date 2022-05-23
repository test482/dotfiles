#!/usr/bin/python

import ipaddress
import socket
import time
from math import sqrt
from sys import argv

def __resolve(host, ipv4=False):
    try:
        addr = ipaddress.ip_address(host)
    except (ipaddress.AddressValueError, ValueError):
        addr = None
        for inetfamily in (socket.AF_INET6, socket.AF_INET):
            try:
                addrinfo = socket.getaddrinfo(host, None, family=inetfamily, proto=socket.IPPROTO_TCP)
                ipaddr = [addr[4][0] for addr in addrinfo]
                if ipaddr and ipaddr[0]:
                    addr = ipaddress.ip_address(ipaddr[0])
                    if not ipv4:
                        break
            except Exception:
                pass
        if not addr:
            print('no such host', host)
            return
    return addr

def do_tcping(args):
    ''' tcping <host> <port> [-4] [-6]'''
    rargs = [a for a in args if a.startswith('-')]
    args = [a for a in args if not a.startswith('-')]
    if not args:
        print('missing host')
        return
    if len(args) == 1:
        args.append('80')
    try:
        args[1] = int(args[1])
        assert 0 <= args[1] < 65536 # the python way
    except (ValueError, AssertionError):
        print('bad port')
        return
    host, port = args[:2]
    addr = __resolve(host, '-4' in rargs)
    if not addr:
        return
    if isinstance(addr, ipaddress.IPv6Address):
        family = socket.AF_INET6
    else:
        family = socket.AF_INET
    addr = str(addr)
    l_time = list()
    try:
        while True:
            try:
                sock = socket.socket(family, socket.SOCK_STREAM)
                sock.settimeout(2)
                _st = time.time()
                sock.connect((addr, port))
                sock.shutdown(socket.SHUT_RDWR)
                _ct = time.time() - _st
                l_time.append(_ct)
                print(f'host={addr} port={port} time={_ct*1000:.2f}ms')
                sock.close()
            except socket.timeout:
                l_time.append(-1.0)
                print(f'host={addr} port={port} time=timeout')
            except KeyboardInterrupt:
                break
            if len(l_time):
                try:
                    time.sleep(1)
                except KeyboardInterrupt:
                    break
            else:
                break
    except OSError as err:
        print(err)
        return
    finally:
        sock.close()
    if not l_time:
        l_time.append(-1.0)
    timeouts = len([i for i in l_time if i < 0])
    effective = [i*1000 for i in l_time if i > 0]
    rtt = effective.copy()
    if not effective:
        rtt.append(0.0)
    rttsquared = [i**2 for i in rtt]
    calc_mdev = lambda: sqrt(sum(rttsquared)/len(rtt) - (sum(rtt)/len(rtt))**2)
    print((f'--- {addr}:{port} tcping statistics ---\n'
           f'{len(l_time)} connections made, {len(effective)} received, '
           f'{timeouts/len(l_time)*100:.1f}% packet loss, time {sum(effective):.2f}ms\n'
           f'rtt min/avg/max/mdev = {min(rtt):.2f}/{sum(rtt)/len(rtt):.2f}/'
           f'{max(rtt):.2f}/{calc_mdev():.2f} ms')
    )

if __name__ == "__main__":
    do_tcping(argv[1:])
