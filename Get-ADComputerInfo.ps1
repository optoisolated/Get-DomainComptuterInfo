CLS
Import-Module ActiveDirectory

$OutFile = "C:\Temp\ADComputerInfo.csv"
$SearchBase = "CN=Computers,DC=domain,DC=local"

$ADComputers = Get-ADComputer -Filter * -SearchBase $SearchBase -Properties *
"ComputerName,IPAddress,Site,Username" | Out-File $OutFile

ForEach ($Computer in $ADComputers) {
    $DNSHost = $Computer.DNSHostName

    # Resolve the IP Address of the computer, required to determine the site
    $IPaddress = $(Resolve-DNSName -name $DNSHost -Type A -Erroraction SilentlyContinue).IPAddress

    # If an IP address can be found...
    If ($IPAddress) {
        # .. work out the associated site
        $command = 'cmd.exe /C ' + "NLTEST /dsaddresstosite:$IPAddress"
        $Response = Invoke-Expression -Command:$command
        $SiteInfo = $Response.split([Environment]::NewLine)[2]

        # And then use a WMI query to find out the computer's user (if possible)
        $UN = Get-WmiObject -class Win32_ComputerSystem -computername $($DNSHost) -ErrorAction SilentlyContinue
        If ($UN.Username.Length -eq 0) { 
            $Username = "<unknown>" 
        } Else { 
            $Username = $UN.Username
        }

        # Store in the output file
        $Output = "$($DNSHost),$($IPAddress),$($SiteInfo.Split(" ")[5]),$($Username)"
        $Output
        $Output | Out-File $OutFile -Append
    }
}
