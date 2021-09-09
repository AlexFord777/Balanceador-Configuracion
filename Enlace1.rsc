# feb/24/2021 23:49:24 by RouterOS 6.47.8
# software id = 
#
#
#
/interface bridge
add name=lo
/interface ethernet
set [ find default-name=ether10 ] comment=Administrador name=ether1
set [ find default-name=ether1 ] comment=Enlace-2 name=ether2
set [ find default-name=ether2 ] comment=Enlace-3 name=ether3
set [ find default-name=ether3 ] name=ether4
set [ find default-name=ether4 ] name=ether5
set [ find default-name=ether5 ] name=ether6
set [ find default-name=ether6 ] name=ether7
set [ find default-name=ether7 ] name=ether8
set [ find default-name=ether8 ] name=ether9
set [ find default-name=ether9 ] name=ether10
/interface list
add name=WAN
add name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/routing ospf area
add area-id=0.0.0.1 name=area1
/routing ospf instance
set [ find default=yes ] router-id=10.255.255.3
/interface list member
add interface=ether1 list=WAN
add interface=ether2 list=LAN
add interface=ether3 list=LAN
/ip address
add address=10.0.0.10/29 comment=Administrador interface=ether1 network=\
    10.0.0.8
add address=10.1.0.1/29 comment=Enlace-2 interface=ether2 network=10.1.0.0
add address=10.1.0.9/29 comment=Enlace-3 interface=ether3 network=10.1.0.8
add address=10.255.255.3 comment=Loopback interface=lo network=10.255.255.3
/ip dhcp-client
add disabled=no interface=ether1
/ip dns
set servers=1.1.1.1,1.0.0.1
/routing ospf interface
add authentication=md5 authentication-key=ospfnet interface=ether1 \
    network-type=point-to-point
add authentication=md5 authentication-key=ospfnet interface=ether2 \
    network-type=point-to-point
add authentication=md5 authentication-key=ospfnet interface=ether3 \
    network-type=point-to-point
/routing ospf network
add area=backbone network=10.0.0.8/29
add area=area1 network=10.1.0.0/29
add area=area1 network=10.1.0.8/29
/system identity
set name=Enlace-1
/tool romon
set enabled=yes
