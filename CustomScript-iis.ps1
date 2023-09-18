Install-WindowsFeature -name Web-Server -IncludeManagementTools

Copy-Item "C:\inetpub\wwwroot\iisstart.htm" -Destination "C:\inetpub\wwwroot\iisstart-bck.htm"

Set-Content -path "C:\inetpub\wwwroot\iisstart.htm" -value "<html><head><title>Hello World</title></head><body><h1>Hello World</h1><p>Hostname: $($env:COMPUTERNAME)</p></body></html>"
Restart-Service -Name W3SVC