param([string]$IP="no", [string]$password="", [string]$user="Administrator", [string]$version="6.1.1.79", [string]$type=1, [string]$logName="c:\logName", [string]$justDownload="0", [string]$keepOldBuilds="0")


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
Function MakeSession ($machinename, $password, $login, $version, $type, $logName, $justDownload, $keepOldBuilds)
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

    #$machinename="10.10.65.45"
    #$password=
    #$login="Administrator"
   # $version="6.1.2.115" 
   # $type=1
    $feedbackShare="c:\$feedbackShareName"

     #Waiting 5
   
     #Restart-Service winRM
   
   Test-Connection -ComputerName $machinename -Quiet
    
    $pw = convertto-securestring -AsPlainText -Force -String $password
    $cred = new-object -typename System.Management.Automation.PSCredential -Argumentlist $login, $pw

    #setting name and location for the feedback report file

    $reportShortName="\report."+$machinename+".txt"
    $reportNetName="\\"+$localServerIP+"\"+$feedbackShareName+$reportShortName
    $reportFullName=$feedbackShare+$reportShortName

    
 
 #checking if feedback share folder exists. If not - creating it

    if(!(Test-Path -Path $feedbackShare)) 
    {
    # Service!!! Logging "Shared directory for process launch result report was not found, so creating one c:\Ashare and sharing it" $logName

    New-Item -Path $feedbackShare -ItemType directory -Force
    }
    #resharing the local feedback share

    $unShareCommand=" net share "+"$feedbackShareName /delete "
    cmd /c $unShareCommand
    $shareCommand=" net share "+"$feedbackShareName="+$feedbackShare+" /grant:Administrator,FULL"
    cmd /c $shareCommand
    
   
  
    Remove-Item -Path $reportFullName -Force
    #Remove-Item -Path C:\xampp\htdocs\logs\PS\display.log -Force
    #Remove-Item -Path C:\xampp\htdocs\logs\PS\upgrade.log -Force

    #convert type to text view for displaying
   # switch ($type) 
     #       { 
      #           1 {$typeText="Core" }
      #           2 {$typeText="Agent x64"} 
       #          3 {$typeText ="Agent x32"}
        
       #         default {$typeText="WTF?"}
        #    }
    
    switch ($type) 
            { 
                 1 { Logging "Upgrade mode Core"  $logName
                   $installer = "Core-X64-"+$version+".exe"
                   $typeText="Core" } 
                 2 { Logging "Upgrade mode Agent 64"  $logName
                   $installer = "Agent-X64-"+$version+".exe"
                   $typeText="Agent x64" } 
                 3 { Logging "Upgrade mode Agent 32"  $logName
                   $installer = "Agent-X86-"+$version+".exe"
                   $typeText ="Agent x32" } 
        
                default {Logging "Upgrade mode Core"  $logName
                    "Core-X64-"+$version+".exe"}
            }
    #ncrypt password
    $passwDisplay=$password.subString(0, [System.Math]::Min(4, $password.Length))+"****"
   
    Logging "Submitted values: <br>IP: $machinename <br>Password: $passwDisplay <br>Login: $login <br>Version: $version <br>Product: $typeText <br> Just download: $justDownload <br> Keep old builds: $keepOldBuilds <br>" $logName
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
    
    $netUseCommand="net use "+$buildsShareAddress+" /USER:"+$buildsShareUser+" "+$buildsSharePassword
    $netUseDelete="net use * /delete"
    
    #cmd /c $netUseCommand
    
#check for directory with version name availability
    
    $testPath=$buildsShareAddress+"\"+$version+"\"+$installer
     if ((Test-Path -Path $testPath ) -eq  0)
    {
    Logging "Specified build was not found on networkshare $buildsShareAddress"  $logName
    exit
    }
    else 
    {
    # Service!!! Logging "Test-Path to build file on network share passed" $logName
    }


     # Service!!! Logging "Making session"  $logName

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
     $disk =  Invoke-Command -Session $session -ScriptBlock { Get-WmiObject Win32_LogicalDisk -ComputerName $args[0] -Filter "DeviceID='C:'" | Foreach-Object {$_.FreeSpace}} -ArgumentList $machinename 
     $diskDisplay=$disk/1000000
     if($disk -gt 13000000000)
     {   
        
         # Service!!! Logging "c drive has $diskDisplay MB free "  $logName
      }
       
      else
        {
            Logging "Not enough space on C drive - just $diskDisplay GB, install may fail" $logName
        }

         
            

          
             # Waiting 5
  

             # get-item wsman:\localhost\Client\TrustedHosts
   
            $copyPath="xcopy $buildsShareAddress\"+$version+"\"+$installer+" c:\latest\* /y"
            $robocopy= "robocopy $buildsShareAddress\"+$version+"\ c:\latest\ "+$installer
  
           
            
          
            #Invoke-Command -Session $session -ScriptBlock { cmd /c $args[0]} -ArgumentList $netUseCommand
             #  if($keepOldBuilds -eq 0)
            #{
                # Invoke-Command -Session $session -ScriptBlock { cmd /c del c:\latest\*.exe}
                # Logging "deleting present in c:\latest builds"  $logName
            #}
           # Invoke-Command -Session $session -ScriptBlock {cmd /c $args[0]} -ArgumentList $copyPath
           # Logging "Copy $installer installer using $copyPath command "  $logName

            
            if($keepOldBuilds -eq 0)
            {
                Invoke-Command -Session $session -ScriptBlock { cmd /c del c:\latest\*.exe}
                Logging "Deleting old builds in c:\latest if present"  $logName
                
            }
            #$installer="Core-X64-6.1.2.113.exe"
            $counterForCopyBuildRetry=0
            $testPathIstaller="c:/latest/"+$installer
            $buildCopied= Invoke-Command -Session $session -ScriptBlock {Test-Path -Path $args[0]} -ArgumentList $testPathIstaller
            
            while ($buildCopied -ne $True)
            {
                Invoke-Command -Session $session -ScriptBlock { cmd /c $args[0]} -ArgumentList $netUseCommand
                Invoke-Command -Session $session -ScriptBlock {cmd /c $args[0]} -ArgumentList $copyPath
                Logging "Copying $installer installer to c:\latest on your machine, try $counterForCopyBuildRetry "  $logName
                Waiting 3
                $buildCopied= Invoke-Command -Session $session -ScriptBlock {Test-Path -Path $args[0]} -ArgumentList $testPathIstaller
                Logging "test path for build presence $buildCopied" $logName
                Invoke-Command -Session $session -ScriptBlock { cmd /c $args[0]} -ArgumentList $netUseDelete
                $counterForCopyBuildRetry++
                if($counterForCopyBuildRetry -eq 5) 
                {Logging "Error 1. Copy Command probably did not work. <br> If installer was not copied to c:\latest, please go back and try again <br> if issue reproduce is stable - contact support on home page" $logName
                break}
            }
            Invoke-Command -Session $session -ScriptBlock { cmd /c $args[0]} -ArgumentList $netUseDelete
            
            
            #Waiting 20
            if($justDownload -eq "0" )
            {

                Logging "Launching $installer installer"  $logName
                 #Waiting 5
    
                # Service!!! Logging "Startting upgrade for $machinename was successful if you get process details under this message"  $logName
                $installerLaunchCommand="c:\latest\"+$installer+" /silent"
                $process = get-wmiobject -query "SELECT * FROM Meta_Class WHERE __Class = 'Win32_Process'" -namespace "root\cimv2" -computername $machinename -credential $cred
                $results = $process.Create( $installerLaunchCommand) 
                # Service!!! Logging "Probably launched <br> Even if installation will be unsuccessful, installer will stay on your machine in c:\latest"  $logName

                #receiving feedback from remote machine

                $netUseCommandFeedBack=" net use "+"\\"+$localServerIP+"\"+$feedbackShareName+" /USER:"+$env:UserDomain+"\"+$env:UserName+" "+$localServerPassword
  
                Invoke-Command -Session $session -ScriptBlock { cmd /c $Args[0]} -ArgumentList $netUseCommandFeedBack
                if ($type -eq 1) {Invoke-Command -Session $session -ScriptBlock {Get-Process Core-* >>$args[0]}  -ArgumentList $reportNetName}
                else { Invoke-Command -Session $session -ScriptBlock {Get-Process Agent-* >> $args[0]} -ArgumentList $reportNetName}
                Invoke-Command -Session $session -ScriptBlock { cmd /c $Args[0]} -ArgumentList $netUseDelete
    
                #rename log file
                if(Test-Path -Path $reportFullName)
                {
                     Get-Content $reportFullName | Out-File $logName -append
                     Logging "<br> Installer was launched, if you get process details above" $logName
                }
                else
                {
                     Logging "feedback file was not created, don't know if launch was successful" $logName
                }
            }
    

     # Service!!! Logging "Removing temp share" $logName
          cmd /c $unShareCommand
          cmd /c rd $feedbackShare /s /q
# Service!!! Logging "Log file named $logName. <br> Disconnecting session"  $logName
 Remove-PSSession $session >> $logName
 Add-Content $logName "<br> </div> </div> </body> </html>"
 		
   
      
    #Invoke-Command -Session $session -ScriptBlock {Restart-Service winrm}
    #Remove-PSSession $session
}

#taskkill /im powershell.exe /f


MakeSession "$IP" "$password" "$user" "$version" "$type" "$logName" "$justDownload" "$keepOldBuilds"

