# feb/24/2021 23:39:56 by RouterOS 6.47.8
# software id = 
#
#
#
/interface bridge
add name=lo
/interface ethernet
set [ find default-name=ether1 ] comment=Balanceador
set [ find default-name=ether8 ] comment=Enlace-1 name=ether2
set [ find default-name=ether9 ] name=ether3
set [ find default-name=ether10 ] name=ether4
set [ find default-name=ether2 ] name=ether5
set [ find default-name=ether3 ] name=ether6
set [ find default-name=ether4 ] name=ether7
set [ find default-name=ether5 ] name=ether8
set [ find default-name=ether6 ] name=ether9
set [ find default-name=ether7 ] name=ether10
/interface list
add name=WAN
add name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/routing ospf instance
set [ find default=yes ] router-id=10.255.255.2
/interface list member
add interface=ether1 list=WAN
add interface=ether2 list=LAN
/ip address
add address=10.0.0.2/30 interface=ether1 network=10.0.0.0
add address=10.255.255.2 interface=lo network=10.255.255.2
add address=10.0.0.9/29 interface=ether2 network=10.0.0.8
/ip dhcp-client
add disabled=no interface=ether1
/ip dns
set servers=1.1.1.1,1.0.0.1
/ip firewall address-list
add address=192.168.0.0/16 list=RFC1918
add address=172.16.0.0/12 list=RFC1918
add address=10.0.0.0/8 list=RFC1918
add address=facebook.com list=WebsBloqueadas
/ip firewall filter
add action=accept chain=input connection-state=established,related
add action=drop chain=input connection-state=invalid
add action=accept chain=forward connection-state=established,related
add action=drop chain=forward connection-state=invalid
add action=drop chain=forward comment=Spammers dst-port=25,110,465,587 \
    in-interface-list=LAN protocol=tcp
add action=drop chain=forward comment="Bloquear Sitios Webs" \
    dst-address-list=WebsBloqueadas in-interface-list=LAN
add action=drop chain=forward comment="Corte a Clientes Morosos" \
    in-interface-list=LAN src-address-list=Corte-Morosos
/ip firewall nat
add action=masquerade chain=srcnat comment=NAT out-interface-list=WAN \
    src-address-list=RFC1918
/routing ospf interface
add authentication=md5 authentication-key=ospfnet interface=ether1 \
    network-type=point-to-point
add authentication=md5 authentication-key=ospfnet interface=ether2 \
    network-type=point-to-point
/routing ospf network
add area=backbone network=10.0.0.0/30
add area=backbone network=10.0.0.8/29
/system identity
set name=Administrador
/tool romon
set enabled=yes
