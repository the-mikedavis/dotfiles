#! /usr/bin/env fish

if [ (nordvpn status | grep Connected) ]
  set -l ip (nordvpn status | grep IP | sed 's/Your new IP: //')
  set -l city (nordvpn status | grep City | sed 's/City: //')

  echo ""$ip"@"$city
end
