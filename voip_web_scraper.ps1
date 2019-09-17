
param (
    [string]$url,
    [string]$outfile
)


$phoneSerialNumber = ''
$phoneMACAddress = ''
$phoneHostName = ''
$lengthOfSerialNumberPadding = 12 # "Serial Number" is 12 characters long starting at e
$lengthOfMACAddressPadding = 10 # "MAC Address" is 10 characters long starting at A
$lengthOfHostNamePadding = 8 # "Host Name" is 9 characters long starting at o
$col1 = "Host Name"
$col2 = "MAC Address"
$col3 = "Serial Number"
$col4 = "IP Address"


# Pull phone web page
try{
    $website = Invoke-WebRequest $url
}
catch {
    exit
}

# Find Serial Number Header and read following SN
$indexOfSerialNumberHeader = $website.ParsedHtml.body.outerText.IndexOf('Serial')
$phoneSerialNumber += 1..11 | %{$website.ParsedHtml.body.outerText[$indexOfSerialNumberHeader + $lengthOfSerialNumberPadding + $_]}
$phoneSerialNumber = $phoneSerialNumber -replace '\s',''

# Find MAC Address Header and read following MAC
$indexOfMACAddressHeader = $website.ParsedHtml.body.outerText.IndexOf('MAC')
$phoneMACAddress += 1..12 | %{$website.ParsedHtml.body.outerText[$indexOfMACAddressHeader + $lengthOfMACAddressPadding + $_]}
$phoneMACAddress = $phoneMACAddress -replace '\s',''

# Find Host Name Header and read following Host Name
$indexOfHostNameHeader = $website.ParsedHtml.body.outerText.IndexOf('Host Name')
$phoneHostName += 1..15 | %{$website.ParsedHtml.body.outerText[$indexOfHostNameHeader + $lengthOfHostNamePadding + $_]}
$phoneHostName = $phoneHostName -replace '\s',''


#get-variable phoneHostName, phoneSerialNumber, phoneMACAddress | Export-Csv -Path phone.csv -NoTypeInformation

$report = @()
$report += New-Object psobject -Property @{$col1 = $phoneHostName; $col2 = $phoneMACAddress; $col3 = $phoneSerialNumber; $col4 = $url}
$report | export-csv -Append -path $outfile -NoTypeInformation
