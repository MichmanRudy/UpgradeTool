param([string]$IP="no", [string]$password="", [string]$user="Administrator", [string]$logName)


Function Logging ($line, $logName)
{
Write-Host  $line
Add-content $logName ((Get-Date -f 'dd/MM/yy HH:mm:ss')+": $line"+"<br> `n")
}



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
Function checkVersion ($machinename, $password, $login, $logName)
{
  
   #$machinename="192.168.64.183" 
   #$password=
   #$login="Administrator"
   #$version="6.1.0.645" 
   #$type=2
   #Waiting 5
     

   Test-Connection -ComputerName $machinename -Quiet
    
    $pw = convertto-securestring -AsPlainText -Force -String $password
    $cred = new-object -typename System.Management.Automation.PSCredential -Argumentlist $login, $pw
    
    #ncrypt password
    $passwDisplay=$password.subString(0, [System.Math]::Min(4, $password.Length))+"****"
   
    Logging "Submitted values: $machinename $passwDisplay  $login $version $type" $logName
    set-item wsman:\localhost\Client\TrustedHosts -value $machinename -Force
   #Waiting 1
   Logging "Setting $machinename to trusted hosts" $logName


    if ((Test-Connection -ComputerName $machinename -Quiet) -eq  0)
    {
    Logging "Cannot contact the specified machine" $logName
    exit
    }
    else 
    {
    Logging "Test-Connection function passed" $logName
    }
  


   
     $CoreService= Get-Service -ComputerName $machinename -Name RapidRecoveryCore -ErrorAction SilentlyContinue
    if($CoreService.Length -eq 0) {Logging "No Core service installed"}
    else
        {
             Logging "Core version "  $logName
             
             (Get-WMiObject -Credential $cred -ComputerName $machinename -Class Win32_Product | Where-Object -Property "Name" -eq "AppRecovery Core" | Select-Object -Property "Version").version  >> $logName
            Add-content  $logName "<br>"            
        }
       
   
   $AgentService=Get-Service -ComputerName $machinename -Name RapidRecoveryAgent -ErrorAction SilentlyContinue
    if($AgentService.Length -eq 0) {Logging "No Agent service installed"}
    else
        {
            Logging "Agent version " $logName
            
            (Get-WMiObject -Credential $cred -ComputerName $machinename -Class Win32_Product | Where-Object -Property "Name" -eq "AppRecovery Agent" | Select-Object -Property "Version").version >> $logName
              Add-content  $logName "<br>" 
        }
         

        
  
 Logging "Log file named $logName." $logName

   
    
}

#taskkill /im powershell.exe /f

#taskkill /im powershell.exe /f
checkVersion "$IP" "$password" "$user" "$logName"

