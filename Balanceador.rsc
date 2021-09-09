# feb/24/2021 23:23:28 by RouterOS 6.47.8
# software id = 
#
#
#
/interface bridge
add name=lo
/interface ethernet
set [ find default-name=ether8 ] comment=ISP-1 name=ether1
set [ find default-name=ether9 ] comment=ISP-2 name=ether2
set [ find default-name=ether10 ] comment=LAN name=ether3
set [ find default-name=ether1 ] name=ether4
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
set [ find default=yes ] distribute-default=if-installed-as-type-1 router-id=\
    10.255.255.1
/ip neighbor discovery-settings
set discover-interface-list=all
/interface list member
add interface=ether1 list=WAN
add interface=ether2 list=WAN
add interface=ether3 list=LAN
/ip address
add address=172.16.240.2/30 interface=ether1 network=172.16.240.0
add address=172.16.250.2/30 interface=ether2 network=172.16.250.0
add address=10.0.0.1/30 interface=ether3 network=10.0.0.0
add address=10.255.255.1 interface=lo network=10.0.0.0
/ip dhcp-client
add disabled=no interface=ether1
/ip dns
set servers=1.1.1.1,1.0.0.1
/ip firewall address-list
add address=192.168.0.0/16 list=RFC1918
add address=172.16.0.0/12 list=RFC1918
add address=10.0.0.0/8 list=RFC1918
/ip firewall filter
add action=accept chain=input connection-state=established,related
add action=drop chain=input connection-state=invalid
add action=accept chain=input comment="Aceptar Conexiones al Winbox" \
    dst-port=8491 in-interface-list=WAN protocol=tcp
add action=drop chain=input comment="Bloquear todo trafico desde Internet" \
    in-interface-list=WAN
add action=accept chain=forward connection-state=established,related
add action=drop chain=forward connection-state=invalid
/ip firewall mangle
add action=accept chain=prerouting comment=\
    "Inicio Balanceo PCC-Marcado de paquetes" dst-address=10.111.0.0/24 \
    in-interface-list=LAN
add action=accept chain=prerouting dst-address=10.112.0.0/24 \
    in-interface-list=LAN
add action=mark-connection chain=prerouting connection-mark=no-mark \
    in-interface=ether1 new-connection-mark=ISP1_conn passthrough=yes
add action=mark-connection chain=prerouting connection-mark=no-mark \
    in-interface=ether2 new-connection-mark=ISP2_conn passthrough=yes
add action=mark-connection chain=prerouting connection-mark=no-mark \
    dst-address-type=local in-interface-list=LAN new-connection-mark=\
    ISP1_conn passthrough=yes per-connection-classifier=both-addresses:2/0
add action=mark-connection chain=prerouting connection-mark=no-mark \
    dst-address-type=local in-interface-list=LAN new-connection-mark=\
    ISP2_conn passthrough=yes per-connection-classifier=both-addresses:2/1
add action=mark-routing chain=prerouting connection-mark=ISP1_conn \
    in-interface-list=LAN new-routing-mark=to_ISP1 passthrough=yes
add action=mark-routing chain=prerouting connection-mark=ISP2_conn \
    in-interface-list=LAN new-routing-mark=to_ISP2 passthrough=yes
add action=mark-routing chain=output connection-mark=ISP1_conn \
    new-routing-mark=to_ISP1 passthrough=yes
add action=mark-routing chain=output comment="Fin Balanceo PCC" \
    connection-mark=ISP2_conn new-routing-mark=to_ISP2 passthrough=yes
/ip firewall nat
add action=masquerade chain=srcnat comment=NAT out-interface-list=WAN \
    src-address-list=RFC1918
/ip firewall raw
add action=drop chain=prerouting comment="DNS Flood" dst-port=53 \
    in-interface-list=WAN protocol=udp
add action=drop chain=prerouting comment="DNS Flood" dst-port=53 \
    in-interface-list=WAN protocol=tcp
/ip route
add distance=1 gateway=9.9.9.9 routing-mark=to_ISP1
add distance=2 gateway=4.2.2.2 routing-mark=to_ISP1
add distance=1 gateway=4.2.2.2 routing-mark=to_ISP2
add distance=2 gateway=9.9.9.9 routing-mark=to_ISP2
add distance=1 gateway=9.9.9.9
add distance=2 gateway=4.2.2.2
add comment="Monitorear Internet ISP-2" distance=1 dst-address=4.2.2.2/32 \
    gateway=172.16.250.1 scope=10
add comment="Monitorear Internet ISP-1" distance=1 dst-address=9.9.9.9/32 \
    gateway=172.16.240.1 scope=10
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set ssh disabled=yes
set api disabled=yes
set winbox port=8491
set api-ssl disabled=yes
/routing ospf interface
add authentication=md5 authentication-key=ospfnet interface=ether3 \
    network-type=point-to-point
add interface=lo network-type=broadcast passive=yes
/routing ospf network
add area=backbone network=10.0.0.0/30
/system identity
set name=Balanceador
/tool romon
set enabled=yes
