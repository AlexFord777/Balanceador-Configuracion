# feb/25/2021 00:02:21 by RouterOS 6.47.8
# software id = 
#
#
#
/interface bridge
add name=lo
/interface ethernet
set [ find default-name=ether6 ] comment=Enlace-1 name=ether1
set [ find default-name=ether7 ] comment="LAN donde va los Access Point" \
    name=ether2
set [ find default-name=ether8 ] comment=Enlace-2 name=ether3
set [ find default-name=ether9 ] name=ether4
set [ find default-name=ether10 ] name=ether5
set [ find default-name=ether1 ] name=ether6
set [ find default-name=ether2 ] name=ether7
set [ find default-name=ether3 ] name=ether8
set [ find default-name=ether4 ] name=ether9
set [ find default-name=ether5 ] name=ether10
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp_pool0 ranges=172.16.3.2-172.16.3.254
/ip dhcp-server
add address-pool=dhcp_pool0 disabled=no interface=ether2 name=dhcp1
/queue simple
add max-limit=20M/20M name=Usuario-3 target=172.16.2.254/32
/queue type
add kind=pcq name=10M-Bajada pcq-classifier=dst-address pcq-rate=10M
add kind=pcq name=10M-Subida pcq-classifier=src-address pcq-rate=10M
/queue simple
add max-limit=10M/10M name=Usuario-1 queue=10M-Subida/10M-Bajada target=\
    172.16.3.254/32
add max-limit=3M/3M name=Usuario-2 queue=10M-Subida/10M-Bajada target=\
    172.16.3.253/32
/routing ospf area
add area-id=0.0.0.1 name=area1
/routing ospf instance
set [ find default=yes ] router-id=10.255.255.5
/ip address
add address=10.1.0.10/29 interface=ether1 network=10.1.0.8
add address=172.16.3.1/24 interface=ether2 network=172.16.3.0
add address=10.255.255.5 interface=lo network=10.255.255.5
add address=10.1.0.18/29 interface=ether3 network=10.1.0.16
/ip dhcp-client
add disabled=no interface=ether1
/ip dhcp-server network
add address=172.16.3.0/24 gateway=172.16.3.1
/ip dns
set servers=1.1.1.1,1.0.0.1
/routing ospf interface
add authentication=md5 authentication-key=ospfnet interface=ether1 \
    network-type=point-to-point
add interface=ether2 network-type=broadcast passive=yes
add authentication=md5 authentication-key=ospfnet interface=ether3 \
    network-type=point-to-point
/routing ospf network
add area=area1 network=10.1.0.8/29
add area=area1 network=172.16.3.0/24
add area=area1 network=10.1.0.16/29
/system identity
set name=Enlace-3
/tool romon
set enabled=yes
