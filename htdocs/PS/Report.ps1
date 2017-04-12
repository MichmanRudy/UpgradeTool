param([string]$name="", [string]$severity="", [string]$description="", [string]$reporter="", [string]$email="", [string]$logName="c:\logName")


Function Logging ($line, $logName)
{
Write-Host  $line
Add-content $logName ((Get-Date -f 'dd/MM/yy HH:mm:ss')+": $line"+"<br> `n")
}


#$password1 = get-content C:\Users\Administrator\Documents\password\moo.txt | convertto-securestring

Function Waiting ($sec)
{
$i=$sec
Logging "Wait for $sec seconds"

# Write-Host -NoNewLine "Waiting for " $sec " seconds "
while ($i -gt 0)
    {
       Write-Host -NoNewLine "-" 
       Start-Sleep -Seconds 1
       $i -=1
    }
Write-Host -NoNewLine "-> "
Write-Host "Go on" 

}
Function ReportIssue ($name, $severity, $description, $reporter, $email, $logName)
{
$settingsFile="C:\Users\Administrator\Documents\UpgradeToolSettings.txt"
    if(Test-Path -Path $settingsFile)
    {

        $EmailLogin = get-content $settingsFile | Select-Object -Index 6
        $EmailDomain= get-content $settingsFile | Select-Object -Index 7
        $EmailPassword= get-content $settingsFile | Select-Object -Index 8
        

     }
     else
     {
     Logging "Upgrade Server is not properly configured. Run 'Configure' from the initial server page" $logName
    exit
     }
     if(!$EmailLogin -or !$EmailDomain -or !$EmailPassword)
     {
     Logging "One of the needed variables is not set in the settings file. Run 'Configure' from the initial server page" $logName
    exit
     }

$EmailFrom =$EmailLogin+"@"+ $EmailDomain
$EmailTo = $email
$Subject = "UpgradeTool Feedback. $name" 
$Body = "$reporter left a feedback. This is issue with $severity severity. The description: $description." 
$SMTPServer = "smtp.gmail.com" 
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("$EmailLogin", "$EmailPassword"); 
$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
Logging "Thank You very much! Your report was sent to the server administrator <br>" $logName

  
 Add-Content $logName "<br> </div> </div> </body> </html>"
 		
   
      
    #Invoke-Command -Session $session -ScriptBlock {Restart-Service winrm}
    #Remove-PSSession $session
}

#taskkill /im powershell.exe /f


ReportIssue "$name" "$severity" "$description" "$reporter" "$email" "$logName"

