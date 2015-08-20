---
layout: post
title: "home network"
description: ""
category: 
tags: []
---

# Terms

- DHCP (Dynamic Host Configuration Protocol) : <https://kb.iu.edu/d/adov>
  - How to check the DHCP server (ip addr or anything)?
  - `sudo cat /var/db/dhcpclient/leases//en0-1,64:76:ba:a5:c8:b0`

# Home Wifi Router

- Check IP address of home wifi router
  - System Preferences > Network > Advanced > TCP/IP > Router
  - or put the command `netstat -nr` to show routing table and check the `default` row.

- `ping <host>` to check the validity of host via TCP/IP
- `arp -a` to show the MAC address of home router
- `traceroute <host>` to show the trace of routing to the specified host

## Troubleshoot

- <https://documentation.meraki.com/zGeneral_Administration/Tools_and_Troubleshooting/Determining_link_state_using_common_network_utilities_-_Mac_OS>
  - the type of errors from `ping`
    - `Request timeout for ...`
    - `ping: sendto: Host is down`
    - `ping: sendto: No route to host`

- toggling wifi:
  - `networksetup -setairportpower airport on`
  - `networksetup -setairportpower airport off`

- show current Wifi network:
  - `networksetup -getairportnetwork en0`

- show available SSID:
  - `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s`

## Network Setting from CLI

- Mac OS
  - <http://www.cnet.com/news/how-to-adjust-network-settings-in-os-x-via-the-command-line/>
  - <http://www.infoworld.com/article/2614879/mac-os-x/top-20-os-x-command-line-secrets-for-power-users.html>
  - <http://osxdaily.com/2010/09/01/set-ip-address-from-the-mac-command-line/>
  - <https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man8/networksetup.8.html>
- Ubuntu: <https://help.ubuntu.com/community/NetworkConfigurationCommandLine/Automatic>

## References

- Check IP Address from various types of devices: <http://www.computerworld.com/article/2474776/network-security/network-security-find-the-ip-address-of-your-home-router.html>
- <http://www.computerhope.com/issues/ch001062.htm>
- <http://www.cyberciti.biz/faq/how-to-find-out-router-mac-address/>
- ping, traceroute: <http://www.cisco.com/c/en/us/support/docs/ios-nx-os-software/ios-software-releases-121-mainline/12778-ping-traceroute.html>
