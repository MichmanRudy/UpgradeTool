param([string]$IP="no", [string]$password="", [string]$user="Administrator", [string]$logName="c:\logName")


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
Function MakeSession ($machinename, $password, $login,$logName)
{
    $settingsFile="C:\Users\Administrator\Documents\UpgradeToolSettings.txt"
    if(Test-Path -Path $settingsFile)
    {

        $localServerAdmin = get-content $settingsFile | Select-Object -Index 0
        $localServerPassword= get-content $settingsFile | Select-Object -Index 1
        $localServerIP=get-content $settingsFile | Select-Object -Index 2
        $feedbackShareName=get-content $settingsFile | Select-Object -Index 3
        $buildsSharePassword=get-content $settingsFile | Select-Object -Index 4
        $buildsShareUser=get-content $settingsFile | Select-Object -Index 5
        $buildsShareAddress=(get-content $settingsFile | Select-Object -Index 9)

     }
     else
     {
     Logging "Upgrade Server is not properly configured. Run 'Configure' from the initial server page" $logName
    exit
     }
     if(!$localServerAdmin -or !$localServerPassword -or !$feedbackShareName -or !$buildsSharePassword -or !$buildsShareUser -or !$buildsShareAddress)
     {
     Logging "One of the needed variables is not set in the settings file. Run 'Configure' from the initial server page" $logName
    exit
     }

    #$machinename="10.10.64.132"
    #$password="raid4us!"
    #$login="Administrator"
   # $version="6.1.2.115" 
   # $type=1
   #$logName="c:\ExampleLog.txt"
    $feedbackShare="c:\$feedbackShareName"

     #Waiting 5
   
     #Restart-Service winRM
   
   Test-Connection -ComputerName $machinename -Quiet
    
    $pw = convertto-securestring -AsPlainText -Force -String $password
    $cred = new-object -typename System.Management.Automation.PSCredential -Argumentlist $login, $pw

    #setting name and location for the feedback report file

    #ncrypt password
    $passwDisplay=$password.subString(0, [System.Math]::Min(4, $password.Length))+"****"
   
    Logging "Submitted values: <br>IP: $machinename <br>Password: $passwDisplay <br>Login: $login <br>"
    set-item wsman:\localhost\Client\TrustedHosts -value $machinename -Force
   #Waiting 1
   # Service!!! Logging "Setting $machinename to trusted hosts"  $logName
#Check on machine availability

    if ((Test-Connection -ComputerName $machinename -Quiet) -eq  0)
    {
    Logging "Cannot contact the specified machine"  $logName
    exit
    }
    else 
    {
    # Service!!! Logging "Test-Connection function passed" $logName
    }
    
  

    $session = new-pssession -computername $machinename -credential $cred
 
    $counter=0
    
  
    while(-not($session))
        {
           
             Logging "$machinename inaccessible! $counter try"  $logName
             $session = new-pssession -computername $machinename -credential $cred
             $counter++
              if( $counter -eq 5) {
                Logging "No way, man. Could not make session, check password maybe? <br> Feel free to ckick browser's 'Back' button and type correct password <br>
                If it doesn't help - launch PowerShell on remote machine and perform 'winrm quickconfig'  <br> "  $logName
             #$D=(Get-Date -f 'dd_MM_yy_HH_mm_ss')
             #$logname=$D+"_"+$machinename +"_Update_script_log.txt"
             #Copy-Item -Path C:\xampp\htdocs\logs\PS\upgrade.log -Dest C:\xampp\htdocs\logs\PS\display.log #move to work dir
             #Rename-Item -Path C:\xampp\htdocs\logs\PS\upgrade.log -NewName "$logname" #move to work dir
                exit
               }
        }
       # Service!!! Logging "Session is created. Here is proof:" $logName
      
       # Service!!! Logging ($session | Select-Object -Property State)  $logName
       # Waiting 5
       Logging "Win 8 PS command execution: <br>" $logName
     Invoke-Command -Session $session -ScriptBlock { dism /online /norestart /disable-feature /featurename:SMB1Protocol}  >> $logName
     Logging "Win 7 PS command execution: <br>" $logName
     Invoke-Command -Session $session -ScriptBlock { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB1 -Type DWORD -Value 0 -Force}  >> $logName
     
    
 Remove-PSSession $session >> $logName
 Add-Content $logName "<br> </div> </div> </body> </html>"
 		
   
}
    #Invoke-Command -Session $session -ScriptBlock {Restart-Service winrm}
    #Remove-PSSession $session


#taskkill /im powershell.exe /f


MakeSession "$IP" "$password" "$user" "$logName"

