
param (
    [int]$start,
    [int]$end,
    [string]$network
)

$sucessfulConnection


for ($i = $start; $i -lt ($end + 1); $i += 1) {
    $ipAddress = $network + $i

    # Check if machine is online
    $checkOnline = Test-Connection -ComputerName $ipAddress -Quiet -count 1
    if ($checkOnline -eq "True") {
        
        # Check if port is open
        $checkHTTPOpen = Test-NetConnection -ComputerName $ipAddress -Port 80
        if ($checkHTTPOpen.TcpTestSucceeded -eq "True") {
            .\voip_web_scraper.ps1 -url $ipAddress -outfile phone_inventory.csv
            $SuccessReport = @()
            $SuccessReport += New-Object psobject -Property @{"IP Address" = $ipAddress; "Status" = "Success!"}
            $SuccessReport | export-csv -Append -path phone_status_report.csv -NoTypeInformation
        } 
        # Document HTTP is not open
        else {
            $SuccessReport = @()
            $SuccessReport += New-Object psobject -Property @{"IP Address" = $ipAddress; "Status" = "HTTP/Port 80 is not open"}
            $SuccessReport | export-csv -Append -path phone_status_report.csv -NoTypeInformation
        }
    } 
    # Document device is not online
    else {
        $failedReport = @()
        $failedReport += New-Object psobject -Property @{"IP Address" = $ipAddress; "Status" = "Not Online"}
        $failedReport | export-csv -Append -path phone_status_report.csv -NoTypeInformation
    }
}
