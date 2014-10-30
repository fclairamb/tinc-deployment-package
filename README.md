TINC deployment package
=======================

# Introduction
The goal of this sample package is to simplify much of the hassle of tinc VPN deployment without compromizing the security.

The sample package is base layout for a VPN setup. It contains two tinc hosts:
* server1 (172.16.66.10)
* server2 (172.16.66.20)

# How it works
The package makes the keys creation automatic.

The first time you will install the package, it will ask you:
* For a name if your hostname is "debian" and use your hostname as the tinc hostname. Modify this if you want two.
* The IP address you will want to attribute this hosts (it will display existing IP addresses first)

Once the installation is finished, you will be able to retrieve the generated public key with the given command.

# Sample usage
First you need to build the package:

    make package

> Obviously, it's better to have it automatically built using something like jenkins and a signed repository.

Then you deploy and install it, this is what the deployment will look like:

    make deploy-remote TARGET=root@192.168.1.142
    ls dist/package/*.deb || make package
    dist/package/myvpn-vpn_0.1_amd64.deb
    scp dist/package/*.deb root@192.168.1.142:/tmp/myvpn-vpn.deb
    myvpn-vpn_0.1_amd64.deb                                                                                                                                                                                    100% 5360     5.2KB/s   00:00    
    ssh root@192.168.1.142 "apt-get install -y tinc ; dpkg -i /tmp/myvpn-vpn.deb"
    Reading package lists...
    Building dependency tree...
    Reading state information...
    tinc is already the newest version.
    0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
    Selecting previously unselected package myvpn-vpn.
    (Reading database ... 22160 files and directories currently installed.)
    Unpacking myvpn-vpn (from /tmp/myvpn-vpn.deb) ...
    Setting up myvpn-vpn (0.1) ...
    Creating keys...
    Existing IP addresses:
    ======================
    /etc/tinc/myvpn/hosts/server1:Subnet = 172.16.66.10
    /etc/tinc/myvpn/hosts/server2:Subnet = 172.16.66.20
    Please choose an IP address:
    172.16.66.30
    OK !
    !!! PLEASE NOTE:
    !!! ============
    !!! Your host file is here:
    !!! /etc/tinc/myvpn/hosts/vm
    !!! scp root@192.168.1.142:/etc/tinc/myvpn/hosts/vm vm
    Creating conf.d/00-name.conf
    Restarting tinc daemons: myvpn.

Then, you will want to retrieve this key. You will simply need to type:

    scp root@192.168.1.142:/etc/tinc/myvpn/hosts/vm hosts/vm
    
And redeploy the key or the whole package to the other hosts.


    
