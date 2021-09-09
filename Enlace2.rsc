# feb/24/2021 23:57:00 by RouterOS 6.47.8
# software id = 
#
#
#
/interface bridge
add name=lo
/interface ethernet
set [ find default-name=ether9 ] comment=Enlace-1 name=ether1
set [ find default-name=ether10 ] comment="LAN donde se conectan los AP" \
    name=ether2
set [ find default-name=ether1 ] comment=Enlace-3 name=ether3
set [ find default-name=ether2 ] name=ether4
set [ find default-name=ether3 ] name=ether5
set [ find default-name=ether4 ] name=ether6
set [ find default-name=ether5 ] name=ether7
set [ find default-name=ether6 ] name=ether8
set [ find default-name=ether7 ] name=ether9
set [ find default-name=ether8 ] name=ether10
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add comment="Conjunto de Direcciones" name=dhcp_pool0 ranges=\
    172.16.2.2-172.16.2.254
add name=dhcp_pool1 ranges=172.16.2.2-172.16.2.254
/ip dhcp-server
add address-pool=dhcp_pool1 disabled=no interface=ether2 name=dhcp1
/routing ospf area
add area-id=0.0.0.1 name=area1
/routing ospf instance
set [ find default=yes ] router-id=10.255.255.4
/ip address
add address=10.1.0.2/29 interface=ether1 network=10.1.0.0
add address=172.16.2.1/24 interface=ether2 network=172.16.2.0
add address=10.255.255.4 interface=lo network=10.255.255.4
add address=10.1.0.17/29 interface=ether3 network=10.1.0.16
/ip dhcp-client
add disabled=no interface=ether1
/ip dhcp-server network
add address=172.16.2.0/24 gateway=172.16.2.1
/ip dns
set servers=1.1.1.1,1.0.0.1
/routing ospf interface
add authentication=md5 authentication-key=ospfnet interface=ether1 \
    network-type=point-to-point
add interface=ether2 network-type=broadcast passive=yes
add authentication=md5 authentication-key=ospfnet interface=ether3 \
    network-type=point-to-point
/routing ospf network
add area=area1 network=10.1.0.0/29
add area=area1 network=172.16.2.0/24
add area=area1 network=10.1.0.16/29
/system identity
set name=Enlace-2
/tool romon
set enabled=yes
