# Get-DomainComptuterInfo
Get's a list of AD Computers, and works out their associated Site, IP address and User.

## TODO
* Optimise the NLTEST Function (its fast enough, but if it was manually grabbing the list of all AD sites, and associated subnets at the beginning, I could make the match instantly. 
* Find a better way to do the user match rather than relying on the WMI Lookup, it often fails and takes an very very long time. Might be worth forking those off into a couple of threaded processes. 
